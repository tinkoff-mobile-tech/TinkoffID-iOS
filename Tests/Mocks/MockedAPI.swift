//
//  MockedAPI.swift
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

final class MockedAPI: IAPI {
    var lastObtainCredentialsCode: String?
    var lastObtainCredentialsClientId: String?
    var lastObtainCredentialsCodeVerifier: String?
    var lastObtainCredentialsRedirectUri: String?
    
    var obtainCredentialsResult: Result<TinkoffTokenPayload, Error>!
    
    func obtainCredentials(with code: String,
                           clientId: String,
                           codeVerifier: String,
                           redirectUri: String,
                           completion: @escaping (Result<TinkoffTokenPayload, Error>) -> Void) {
        lastObtainCredentialsCode = code
        lastObtainCredentialsClientId = clientId
        lastObtainCredentialsCodeVerifier = codeVerifier
        lastObtainCredentialsRedirectUri = redirectUri
        
        completion(obtainCredentialsResult)
    }
    
    var lastObtainCredentialsByTokenRefreshToken: String?
    var lastObtainCredentialsByTokenClientId: String?
    
    var obtainCredentialsByTokenResult: Result<TinkoffTokenPayload, Error>!
    
    func obtainCredentials(with refreshToken: String,
                           clientId: String,
                           completion: @escaping (Result<TinkoffTokenPayload, Error>) -> Void) {
        lastObtainCredentialsByTokenRefreshToken = refreshToken
        lastObtainCredentialsByTokenClientId = clientId
        
        completion(obtainCredentialsByTokenResult)
    }
    
    var lastSignOutToken: String?
    var lastSignOutTokenTypeHint: SignOutTokenTypeHint?
    var lastSignOutClientId: String?
    
    var signOutResult: Result<SignOutResponse, Error>!
    
    func signOut(with token: String,
                 tokenTypeHint: SignOutTokenTypeHint,
                 clientId: String,
                 completion: @escaping (Result<SignOutResponse, Error>) -> Void) {
        lastSignOutToken = token
        lastSignOutTokenTypeHint = tokenTypeHint
        lastSignOutClientId = clientId
        
        completion(signOutResult)
    }
}
