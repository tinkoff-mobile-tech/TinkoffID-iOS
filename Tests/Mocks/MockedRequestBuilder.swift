//
//  MockedRequestBuilder.swift
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
@testable import TinkoffID

final class MockedRequestBuilder: IRequestBuilder {
    
    var lastBuildTokenRequestByCodeCode: String?
    var lastBuildTokenRequestByCodeClientId: String?
    var lastBuildTokenRequestByCodeCodeVerifier: String?
    var lastBuildTokenRequestByCodeRedirectUri: String?
    
    var buildTokenRequestByCodeError: Error?
    var buildTokenRequestByCodeResult: URLRequest!
    
    func buildTokenRequest(with code: String, _ clientId: String, _ codeVerifier: String, _ redirectUri: String) throws -> URLRequest {
        lastBuildTokenRequestByCodeCode = code
        lastBuildTokenRequestByCodeClientId = clientId
        lastBuildTokenRequestByCodeCodeVerifier = codeVerifier
        lastBuildTokenRequestByCodeRedirectUri = redirectUri
        
        if let error = buildTokenRequestByCodeError {
            throw error
        }
        
        return buildTokenRequestByCodeResult
    }
    
    var lastBuildTokenRequestRefreshToken: String?
    var lastBuildTokenRequestClientId: String?
    
    var buildTokenRequestError: Error?
    var buildTokenRequestResult: URLRequest!
    
    func buildTokenRequest(with refreshToken: String, clientId: String) throws -> URLRequest {
        lastBuildTokenRequestRefreshToken = refreshToken
        lastBuildTokenRequestClientId = clientId
        
        if let error = buildTokenRequestError {
            throw error
        }
        
        return buildTokenRequestResult
    }
    
    var lastBuildSignOutRequestToken: String?
    var lastBuildSignOutRequestTokenTypeHint: String?
    var lastBuildSignOutRequestClientId: String?
    
    var buildSignOutRequestError: Error?
    var buildSignOutRequestResult: URLRequest!
    
    func buildSignOutRequest(with token: String, _ tokenTypeHint: String, _ clientId: String) throws -> URLRequest {
        lastBuildSignOutRequestToken = token
        lastBuildSignOutRequestTokenTypeHint = tokenTypeHint
        lastBuildSignOutRequestClientId = clientId
        
        if let error = buildSignOutRequestError {
            throw error
        }
        
        return buildSignOutRequestResult
    }
}
