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
    private let app: TinkoffApp
    
    public init(clientId: String,
                callbackUrl: String,
                app: TinkoffApp) {
        self.clientId = clientId
        self.callbackUrl = callbackUrl
        self.app = app
    }
    
    public func build() -> ITinkoffID {
        let urlSchemeBuilder = URLSchemeBuilder(baseUrlString: app.authUrl)
        let appLauncher = URLSchemeAppLauncher(builder: urlSchemeBuilder,
                                               appUrlScheme: app.urlScheme)
        
        let requestBuilder = RequestBuilder(baseUrl: app.apiBaseUrl)
        let api = API(requestBuilder: requestBuilder)
        
        let codeVerifierGenerator = RFC7636PKCECodeVerifierGenerator()
        let codeChallengeDerivator = RFC7636PKCECodeChallengeDerivator()
        
        let payloadGenerator = PKCEPayloadGenerator(codeVerifierGenerator: codeVerifierGenerator,
                                                    codeChallengeGenerator: codeChallengeDerivator)
        
        let callbackUrlParser = CallbackURLParser()
        
        return TinkoffID(payloadGenerator: payloadGenerator,
                         appLauncher: appLauncher,
                         callbackUrlParser: callbackUrlParser,
                         api: api,
                         clientId: clientId,
                         callbackUrl: callbackUrl)
    }
}
