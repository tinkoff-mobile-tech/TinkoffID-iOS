//
//  URLSchemeBuilder.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

final class URLSchemeBuilder: IURLSchemeBuilder {
    
    enum Error: Swift.Error {
        case unableToInitializeUrl
    }
    
    enum Param: String {
        case clientId
        case codeChallenge
        case codeChallengeMethod
        case callbackUrl
    }
    
    private let baseUrlString: String
    
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }
    
    var baseUrl: URL? {
        URL(string: baseUrlString)
    }
    
    func buildUrlScheme(with options: AppLaunchOptions) throws -> URL {
        let params = [
            Param.clientId: options.clientId,
            .codeChallenge: options.payload.challenge,
            .codeChallengeMethod: options.payload.challengeMethod,
            .callbackUrl: options.callbackUrl
        ]
        
        var components = URLComponents(string: baseUrlString)
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key.rawValue, value: $0.value)
        }
        
        guard let url = components?.url else {
            throw Error.unableToInitializeUrl
        }
        
        return url
    }
}
