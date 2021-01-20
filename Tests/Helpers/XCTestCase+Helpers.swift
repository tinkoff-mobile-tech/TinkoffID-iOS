//
//  XCTestCase+Helpers.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import XCTest

extension XCTestCase {
    
    func assertNoError<T>(message: String = "", _ block: () throws -> T) {
        do {
            _ = try block()
        } catch {
            XCTFail(message)
        }
    }
    
    func assertErrorEqual<T, E: Error & Equatable>(_ expectedError: E,
                                                   message: String = "",
                                                   _ block: () throws -> T) {
        do {
            _ = try block()
            
            XCTFail(message)
        } catch {
            guard let castedError = error as? E else {
                return XCTFail("Unexpected error caught")
            }
            
            XCTAssertEqual(castedError, expectedError)
        }
    }
}
