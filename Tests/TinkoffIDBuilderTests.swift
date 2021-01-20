//
//  TinkoffIDBuilderTests.swift
//  TinkoffID
//
//  Created by Dmitry on 19.01.2021.
//

import XCTest
@testable import TinkoffID

final class TinkoffIDBuilderTests: XCTestCase {
    
    private var builder: TinkoffIDBuilder!
    private lazy var tinkoffId = builder.build() as! TinkoffID
    
    private var clientId = "some_client"
    private var callbackUrl = "nowhere://"
    private var app = TinkoffApp.bank
    
    override func setUpWithError() throws {
        builder = TinkoffIDBuilder(clientId: clientId,
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
