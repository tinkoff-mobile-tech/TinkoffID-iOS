//
//  PKCEPayloadGeneratorTests.swift
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
