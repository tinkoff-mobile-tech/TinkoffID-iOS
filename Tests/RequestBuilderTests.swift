//
//  RequestBuilderTests.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import XCTest
@testable import TinkoffID

class RequestBuilderTests: XCTestCase {
    
    private var builder: RequestBuilder!
    
    private var baseUrl = TinkoffApp.bank.apiBaseUrl

    override func setUpWithError() throws {
        builder = RequestBuilder(baseUrl: baseUrl)
    }
    
    func testBuildingTokenRequestWithCode() {
        // Given
        let code = "c"
        let clientId = "ci"
        let codeVerifier = "cv"
        let redirectUri = "ru"
        
        let expectedHeaders  = [
            "Authorization": "Basic Y2k6",
            "X-SSO-No-Adapter": "true"
        ]
        
        let expectedBodyStringValue = "client_id=\(clientId)&code=\(code)&code_verifier=\(codeVerifier)&grant_type=authorization_code&redirect_uri=\(redirectUri)"
        
        // When
        let request = try! builder.buildTokenRequest(with: code,
                                                     clientId,
                                                     codeVerifier,
                                                     redirectUri)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, baseUrl + "/auth/token")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaders)
        XCTAssertEqual(String(data: request.httpBody!, encoding: .utf8), expectedBodyStringValue)
    }
    
    func testBuildingTokenRequestWithRefreshToken() {
        // Given
        let token = "rt"
        let clientId = "ci"
        
        let expectedHeaders  = [
            "Authorization": "Basic Y2k6",
            "X-SSO-No-Adapter": "true"
        ]
        
        let expectedBodyStringValue = "client_id=\(clientId)&grant_type=refresh_token&refresh_token=\(token)"
        
        // When
        let request = try! builder.buildTokenRequest(with: token, clientId: clientId)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, baseUrl + "/auth/token")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaders)
        XCTAssertEqual(String(data: request.httpBody!, encoding: .utf8), expectedBodyStringValue)
    }
    
    func testBuildingSignOutRequest() {
        // Given
        let token = "rt"
        let tokenType = SignOutTokenTypeHint.refresh.rawValue
        let clientId = "ci"
        
        let expectedHeaders  = [
            "Authorization": "Basic Y2k6"
        ]
        
        let expectedBodyStringValue = "token=\(token)&token_type_hint=\(tokenType)"
        
        // When
        let request = try! builder.buildSignOutRequest(with: token, tokenType, clientId)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, baseUrl + "/auth/revoke")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaders)
        XCTAssertEqual(String(data: request.httpBody!, encoding: .utf8), expectedBodyStringValue)
    }
}
