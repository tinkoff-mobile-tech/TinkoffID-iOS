//
//  MockedRequestBuilder.swift
//  TinkoffID
//
//  Created by Dmitry on 19.01.2021.
//

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
