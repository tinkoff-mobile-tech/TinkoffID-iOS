//
//  TinkoffID.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

final class TinkoffID: ITinkoffID {
    
    // MARK: - Dependencies
    
    private let payloadGenerator: IPKCEPayloadGenerator
    private let appLauncher: IAppLauncher
    private let callbackUrlParser: ICallbackURLParser
    private let api: IAPI
    
    // MARK: - State
    private var currentProcess: AuthProcess?
    
    // MARK: - Properties
    private let clientId: String
    private let callbackUrl: String
    
    init(payloadGenerator: IPKCEPayloadGenerator,
         appLauncher: IAppLauncher,
         callbackUrlParser: ICallbackURLParser,
         api: IAPI,
         clientId: String,
         callbackUrl: String) {
        self.payloadGenerator = payloadGenerator
        self.appLauncher = appLauncher
        self.callbackUrlParser = callbackUrlParser
        self.api = api
        self.clientId = clientId
        self.callbackUrl = callbackUrl
    }
    
    // MARK: - ITinkoffAuthInitiator
    
    var isTinkoffAuthAvailable: Bool {
        appLauncher.canLaunchApp
    }
    
    public func startTinkoffAuth(_ completion: @escaping SignInCompletion) {
        let payload = payloadGenerator.generatePayload()
        let options = AppLaunchOptions(clientId: clientId,
                                       callbackUrl: callbackUrl,
                                       payload: payload)
        let process = AuthProcess(appLaunchOptions: options,
                                  completion: completion)
        
        do {
            try appLauncher.launchApp(with: options)

            currentProcess = process
        } catch {
            completion(.failure(.failedToLaunchApp))
        }
    }
    
    // MARK: - ITinkoffAuthCallbackHandler
    
    public func handleCallbackUrl(_ url: URL) -> Bool {
        guard
            url.absoluteString.hasPrefix(callbackUrl),
            let process = currentProcess,
            let result = callbackUrlParser.parse(url)
        else { return false }
        
        switch result {
        case .cancelled:
            finish(process, with: .cancelledByUser)
        case .unavailable:
            finish(process, with: .unavailable)
        case let .codeObtained(code):
            processCode(code, for: process)
        }
        
        return true
    }
    
    // MARK: - ITinkoffCredentialsRefresher
    
    func obtainTokenPayload(using refreshToken: String,
                            _ completion: @escaping (Result<TinkoffTokenPayload, TinkoffAuthError>) -> Void) {
        api.obtainCredentials(with: refreshToken, clientId: clientId) { result in
            completion(result.mapError { _ in TinkoffAuthError.failedToRefreshCredentials })
        }
    }
    
    // MARK: - ITinkoffSignOutInitiator
    
    public func signOut(accessToken: String, completion: @escaping SignOutCompletion) {
        signOut(with: accessToken, .access, completion)
    }
    
    public func signOut(refreshToken: String, completion: @escaping SignOutCompletion) {
        signOut(with: refreshToken, .refresh, completion)
    }
    
    // MARK: - Private
    
    private func processCode(_ code: String, for process: AuthProcess) {
        api.obtainCredentials(with: code,
                              clientId: process.appLaunchOptions.clientId,
                              codeVerifier: process.appLaunchOptions.payload.verifier,
                              redirectUri: process.appLaunchOptions.callbackUrl) { result in
            let mappedResult = result.mapError { _ in
                TinkoffAuthError.failedToObtainToken
            }
                                
            process.completion(mappedResult)
        }
    }
    
    private func finish(_ process: AuthProcess, with error: TinkoffAuthError) {
        process.completion(.failure(error))
    }
    
    private func signOut(with token: String, _ tokenTypeHint: SignOutTokenTypeHint, _ completion: @escaping SignOutCompletion) {
        api.signOut(with: token, tokenTypeHint: tokenTypeHint, clientId: clientId) { result in
            completion(result.map { _ in {}() })
        }
    }
}
