//
//  TinkoffIDFactoryTests.swift
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

final class TinkoffIDFactoryTests: XCTestCase {
    
    private var factory: TinkoffIDFactory!
    private lazy var tinkoffId = factory.build() as! TinkoffID
    
    private var clientId = "some_client"
    private var callbackUrl = "nowhere://"
    private var app = TinkoffApp.bank
    
    override func setUpWithError() throws {
        factory = TinkoffIDFactory(clientId: clientId,
                                   callbackUrl: callbackUrl,
                                   app: app)
    }
    
    func testParametersInjection() {
        XCTAssertEqual(tinkoffId.clientId, clientId)
        XCTAssertEqual(tinkoffId.callbackUrl, callbackUrl)
    }
    
    func testPayloadGeneratorAssembling() {
        // Given
        let payloadGenerator = tinkoffId.payloadGenerator as? PKCEPayloadGenerator
        
        // Then
        XCTAssertTrue(payloadGenerator?.codeVerifierGenerator is RFC7636PKCECodeVerifierGenerator)
        XCTAssertTrue(payloadGenerator?.codeChallengeDerivator is RFC7636PKCECodeChallengeDerivator)
    }
    
    func testCallbackParserAssembling() {
        XCTAssertTrue(tinkoffId.callbackUrlParser is CallbackURLParser)
    }
    
    func testAppLauncherAssembling() {
        // Given
        let launcher = tinkoffId.appLauncher as? URLSchemeAppLauncher
        
        // Then
        XCTAssertTrue(launcher?.appUrlScheme == app.urlScheme)
        XCTAssertTrue(launcher?.builder is URLSchemeBuilder)
    }
    
    func testApiAssembling() {
        // Given
        let api = tinkoffId.api as? API
        
        // Then
        XCTAssertTrue(api?.requestBuilder is RequestBuilder)
        XCTAssertTrue(api?.requestProcessor is URLSession)
        XCTAssertTrue(api?.responseDispatcher is DispatchQueue)
    }
}
