//
//  RFC7636PKCECodeVerifierGeneratorTests.swift
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

class RFC7636PKCECodeVerifierGeneratorTests: XCTestCase {
    
    private var generator: RFC7636PKCECodeVerifierGenerator!

    override func setUpWithError() throws {
        generator = RFC7636PKCECodeVerifierGenerator()
    }
    
    func testThatGeneratorGeneratesVerifierOfExpectedLength() {
        // Given
        let results = (.zero..<10)
            .map { _ in generator.generateCodeVerifier() }
        
        var unexpectedCharacters = CharacterSet.alphanumerics
        unexpectedCharacters.insert(charactersIn: "-._~")
        unexpectedCharacters.invert()
        
        // When
        let unexpectedResults = results.filter {
            $0.count != 128 && $0.rangeOfCharacter(from: unexpectedCharacters) != nil
        }
        
        // Then
        XCTAssertTrue(unexpectedResults.isEmpty, "\(RFC7636PKCECodeVerifierGenerator.self) produced unexpected results: \(unexpectedResults)")
    }
}
