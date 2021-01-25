//
//  RFC7636PKCECodeVerifierGeneratorTests.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

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
