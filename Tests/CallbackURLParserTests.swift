//
//  CallbackURLParserTests.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 14.01.2021.
//

import XCTest
@testable import TinkoffID

class CallbackURLParserTests: XCTestCase {
    
    private var parser: CallbackURLParser!

    override func setUpWithError() throws {
        parser = CallbackURLParser()
    }

    func testThatCodeObtainedResultWillBeParsedSucessfully() {
        let code = "some_code"
        
        testThatInputUrlString("tinkoffid://?code=\(code)", willProduce: .codeObtained(code))
    }
    
    func testThatCancelledResultWillBeParsedSucessfully() {
        testThatInputUrlString("tinkoffid://?cancelled", willProduce: .cancelled)
    }
    
    func testThatUnavailableResultWillBeParsedSucessfully() {
        testThatInputUrlString("tinkoffid://?unavailable", willProduce: .unavailable)
    }
    
    func testThatIncorrectInputStringWillNotBeParsed() {
        testThatInputUrlString("tinkoffid://some_unknown_param=foobar", willProduce: nil)
    }
    
    // MARK: - Private
    
    private func testThatInputUrlString(_ urlString: String, willProduce expectedResult: CallbackURLParseResult?) {
        // Gived
        let url = URL(string: urlString)!
        
        // When
        let result = parser.parse(url)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
}
