//
//  TinkoffIDBuilder.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 01.04.2020.
//

import Foundation

public final class TinkoffIDBuilder {
    
    private let clientId: String
    private let callbackUrl: String
    private let appConfiguration: TargetAppConfiguration
    private let environmentConfiguration: EnvironmentConfiguration
    
    public convenience init(clientId: String,
                            callbackUrl: String,
                            app: TinkoffApp = .bank,
                            environment: TinkoffEnvironment = .production) {
        self.init(clientId: clientId,
                  callbackUrl: callbackUrl,
                  appConfiguration: app,
                  environmentConfiguration: environment)
    }
    
    public init(clientId: String,
                callbackUrl: String,
                appConfiguration: TargetAppConfiguration,
                environmentConfiguration: EnvironmentConfiguration) {
        self.clientId = clientId
        self.callbackUrl = callbackUrl
        self.environmentConfiguration = environmentConfiguration
        self.appConfiguration = appConfiguration
    }
    
    public func build() -> ITinkoffID {
        let urlSchemeBuilder = URLSchemeBuilder(baseUrlString: appConfiguration.authUrl)
        let appLauncher = URLSchemeAppLauncher(appUrlScheme: appConfiguration.urlScheme,
                                               builder: urlSchemeBuilder,
                                               router: UIApplication.shared)
        
        let requestBuilder = RequestBuilder(baseUrl: environmentConfiguration.apiBaseUrl)
        let api = API(requestBuilder: requestBuilder,
                      requestProcessor: URLSession.shared,
                      responseDispatcher: DispatchQueue.main)
        
        let codeVerifierGenerator = RFC7636PKCECodeVerifierGenerator()
        let codeChallengeDerivator = RFC7636PKCECodeChallengeDerivator()
        
        let payloadGenerator = PKCEPayloadGenerator(codeVerifierGenerator: codeVerifierGenerator,
                                                    codeChallengeDerivator: codeChallengeDerivator)
        
        let callbackUrlParser = CallbackURLParser()
        
        return TinkoffID(payloadGenerator: payloadGenerator,
                         appLauncher: appLauncher,
                         callbackUrlParser: callbackUrlParser,
                         api: api,
                         clientId: clientId,
                         callbackUrl: callbackUrl)
    }
}
