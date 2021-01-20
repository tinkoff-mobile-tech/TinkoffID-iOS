//
//  MockedAPI.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

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
