//
//  PKCEPayloadGeneratorTests.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import XCTest
@testable import TinkoffID

class PKCEPayloadGeneratorTests: XCTestCase {
    
    private var generator: PKCEPayloadGenerator!
    private var codeVerifierGenerator: MockedPKCECodeVerifierGenerator!
    private var codeChallengeDerivator: MockedPKCECodeChallengeDerivator!

    override func setUpWithError() throws {
        codeVerifierGenerator = MockedPKCECodeVerifierGenerator()
        codeChallengeDerivator = MockedPKCECodeChallengeDerivator()
        
        codeChallengeDerivator.stubbedCodeChallengeMethod = "foo"
        codeChallengeDerivator.stubbedDeriveCodeChallengeResult = "bar"
        
        codeVerifierGenerator.stubbedCodeVerifierResult = "baz"
        
        generator = PKCEPayloadGenerator(codeVerifierGenerator: codeVerifierGenerator,
                                         codeChallengeDerivator: codeChallengeDerivator)
    }
    
    func testThatPayloadResultChallengeMethodValueEqualsToDerivatorsOne() {
        // Given
        let result = try! generator.generatePayload()
        
        // When
        let challengeMethod = result.challengeMethod
        
        // Then
        XCTAssertEqual(challengeMethod, codeChallengeDerivator.codeChallengeMethod)
    }
    
    func testThatPayloadResultVerifierEqualsToDerivatorsResult() {
        // When
        let result = try! generator.generatePayload()
        
        // Then
        XCTAssertEqual(result.verifier, codeVerifierGenerator.stubbedCodeVerifierResult)
    }
    
    func testThatDeriveCodeChallengeMethodWillBeInvokedWithCodeVerifierGeneratorResult() {
        // Given
        _ = try! generator.generatePayload()
        
        // Then
        XCTAssertEqual(codeChallengeDerivator.lastDeriveCodeChallengeCodeVerifierParam, codeVerifierGenerator.stubbedCodeVerifierResult)
    }
    
    func testThatPayloadResultChallengeEqualsToDerivatorsResult() {
        // When
        let result = try! generator.generatePayload()
        
        // Then
        XCTAssertEqual(result.challenge, codeChallengeDerivator.stubbedDeriveCodeChallengeResult)
    }
}
