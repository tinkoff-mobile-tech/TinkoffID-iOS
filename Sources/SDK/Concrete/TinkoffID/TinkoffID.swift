//
//  TinkoffID.swift
//  TinkoffID
//
//  Copyright (c) 2021 Tinkoff
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

final class TinkoffID: ITinkoffID {
    
    // MARK: - Dependencies
    
    let payloadGenerator: IPKCEPayloadGenerator
    let appLauncher: IAppLauncher
    let callbackUrlParser: ICallbackURLParser
    let api: IAPI
    let authWebViewBuilder: IAuthWebViewBuilder
    let webViewSourceProvider: IAuthWebViewSourceProvider?
    let universalLinksOnly: Bool
    
    // MARK: - State
    private var currentProcess: AuthProcess?
    private var authWebViewSourceController: UIViewController?
    
    // MARK: - Properties
    let clientId: String
    let callbackUrl: String
    
    init(payloadGenerator: IPKCEPayloadGenerator,
         appLauncher: IAppLauncher,
         callbackUrlParser: ICallbackURLParser,
         api: IAPI,
         authWebViewBuilder: IAuthWebViewBuilder,
         webViewSourceProvider: IAuthWebViewSourceProvider?,
         clientId: String,
         callbackUrl: String,
         universalLinksOnly: Bool) {
        self.payloadGenerator = payloadGenerator
        self.appLauncher = appLauncher
        self.callbackUrlParser = callbackUrlParser
        self.api = api
        self.authWebViewBuilder = authWebViewBuilder
        self.webViewSourceProvider = webViewSourceProvider
        self.clientId = clientId
        self.callbackUrl = callbackUrl
        self.universalLinksOnly = universalLinksOnly
    }
    
    // MARK: - ITinkoffAuthInitiator
    
    var isTinkoffAuthAvailable: Bool {
        appLauncher.canLaunchApp
    }
    
    public func startTinkoffAuth(_ completion: @escaping SignInCompletion) {
        do {
            let payload = try payloadGenerator.generatePayload()
            let options = AppLaunchOptions(clientId: clientId,
                                           callbackUrl: callbackUrl,
                                           payload: payload)
            let process = AuthProcess(appLaunchOptions: options,
                                      completion: completion)
            
            try appLauncher.launchApp(with: options,
                                      universalLinksOnly: self.universalLinksOnly,
                                      completion: { [weak self] didLaunchMobileApp in
                guard let self = self else { return }
                
                guard !didLaunchMobileApp else { return }
                
                if self.universalLinksOnly, let _ = self.webViewSourceProvider {
                    self.openWebView(options: options)
                } else {
                    completion(.failure(.failedToLaunchApp))
                }
            })

            currentProcess = process
        } catch {
            completion(.failure(.failedToLaunchApp))
        }
    }
    
    
    func openWebView(options: AppLaunchOptions) {
        let authWebView = authWebViewBuilder.build(with: options)
        authWebView.delegate = self
        authWebView.open(from: webViewSourceProvider?.getSourceViewController())
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
    
    func signOut(with token: String, tokenTypeHint: SignOutTokenTypeHint, completion: @escaping SignOutCompletion) {
        signOut(with: token, tokenTypeHint, completion)
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

extension TinkoffID: IAuthWebViewDelegate {
    func authWebView(_ webView: IAuthWebView, didOpen url: URL) {
        let handled = handleCallbackUrl(url)
        if handled {
            webView.dismiss()
        }
    }
}
