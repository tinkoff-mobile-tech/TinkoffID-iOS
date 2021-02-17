//
//  URLSchemeBuilder.swift
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
