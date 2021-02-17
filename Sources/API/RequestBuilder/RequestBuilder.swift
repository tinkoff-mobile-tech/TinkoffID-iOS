//
//  RequestBuilder.swift
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

final class RequestBuilder: IRequestBuilder {
    
    enum Endpoint: String {
        case token = "/auth/token"
        case revoke = "/auth/revoke"
    }
    
    enum Param: String {
        case code
        case clientId = "client_id"
        case codeVerifier = "code_verifier"
        case redirectUri = "redirect_uri"
        case grantType = "grant_type"
        case vendor
        case token
        case tokenTypeHint = "token_type_hint"
        case refreshToken = "refresh_token"
    }
    
    enum Header: String {
        case authorization = "Authorization"
        case noAdapter = "X-SSO-No-Adapter"
    }
    
    enum Error: Swift.Error {
        case unableToInitializeRequestUrl
    }
    
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    // MARK: - IRequestBuilder
    
    func buildTokenRequest(with code: String,
                           _ clientId: String,
                           _ codeVerifier: String,
                           _ redirectUri: String) throws -> URLRequest {
        try buildTokenRequest(clientId: clientId, grantType: .grantTypeAuthorizationCode, bodyParams: [
            .code: code,
            .codeVerifier: codeVerifier,
            .redirectUri: redirectUri
        ])
    }
    
    func buildTokenRequest(with refreshToken: String, clientId: String) throws -> URLRequest {
        try buildTokenRequest(clientId: clientId, grantType: .grantTypeRefreshToken, bodyParams: [
            .refreshToken : refreshToken
        ])
    }
    
    func buildSignOutRequest(with token: String,
                             _ tokenTypeHint: String,
                             _ clientId: String) throws -> URLRequest {
        let bodyParams: [Param: String] = [
            .token: token,
            .tokenTypeHint: tokenTypeHint
        ]
        
        let headers: [String: String] = [
            Header.authorization.rawValue: getAuthorizationHeaderValue(for: clientId)
        ]
        
        return try buildRequest(for: .revoke,
                                bodyParams,
                                headers)
    }
    
    // MARK: - Private
    
    private func getAuthorizationHeaderValue(for clientId: String) -> String {
        return String(format: .authorizationHeaderFormat, Data((clientId + ":").utf8).base64EncodedString())
    }
    
    private func buildTokenRequest(clientId: String, grantType: String, bodyParams: [Param: String]) throws -> URLRequest {
        var params = bodyParams
        
        params[.clientId] = clientId
        params[.grantType] = grantType
        
        let headers: [String: String] = [
            Header.authorization.rawValue: getAuthorizationHeaderValue(for: clientId),
            Header.noAdapter.rawValue: String(true)
        ]
        
        return try buildRequest(for: .token,
                                params,
                                headers)
    }
    
    private func buildRequest(for endpoint: Endpoint,
                              _ bodyParams: [Param: String],
                              _ headers: [String: String]) throws -> URLRequest {
        guard let url = URL(string: baseUrl + endpoint.rawValue) else { throw Error.unableToInitializeRequestUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = .httpMethod
        request.httpBody = bodyParams.httpBody
        request.allHTTPHeaderFields = headers
        
        return request
    }
}

// MARK: - Private

private extension Dictionary where Key == RequestBuilder.Param, Value == String {
    var httpBody: Data? {
        map { $0.key.rawValue + "=" + $0.value }
            .sorted()
            .joined(separator: "&")
            .data(using: .utf8)
    }
}

private extension String {
    static let grantTypeAuthorizationCode = "authorization_code"
    static let grantTypeRefreshToken = "refresh_token"
    static let vendorParamValue = "tinkoff_ios"
    static let httpMethod = "POST"
    static let authorizationHeaderFormat = "Basic %@"
}
