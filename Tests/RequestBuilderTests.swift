//
//  RequestBuilderTests.swift
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

import XCTest
@testable import TinkoffID

class RequestBuilderTests: XCTestCase {
    
    private var builder: RequestBuilder!
    
    private var baseUrl = TinkoffEnvironment.production.apiBaseUrl

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
