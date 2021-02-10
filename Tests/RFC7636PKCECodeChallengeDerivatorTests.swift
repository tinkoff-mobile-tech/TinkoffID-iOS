//
//  RFC7636PKCECodeChallengeDerivatorTests.swift
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

class RFC7636PKCECodeChallengeDerivatorTests: XCTestCase {
    
    private var derivator: RFC7636PKCECodeChallengeDerivator!

    override func setUpWithError() throws {
        derivator = RFC7636PKCECodeChallengeDerivator()
    }

    func testThatIncorrectStringWillCauseSerializationErrorThrowing() {
        // Given
        let verifier = "🐞"
        
        // When
        let when = { _ = try self.derivator.deriveCodeChallenge(using: verifier) }
        
        // Then
        assertErrorEqual(RFC7636PKCECodeChallengeDerivator.Error.serializationError,
                         message: "\(RFC7636PKCECodeChallengeDerivator.Error.serializationError) has to be thrown",
                         when)
    }
    
    func testThatCorrectInputDoesNotProduceErrors() {
        // Given
        let verifier = "WCj6N2Fgl2YCuA5zZbJzCAeT6LFy1tJKgINAfs9HH4LC8futoIozrw5_OxWlxkxrgpTrdKttG2go--w5voQ4TtT8h8XNtMEukp5Ml74k8b6x68EVZf8UJRkc6EDP54au"
        
        // When
        let when = { try self.derivator.deriveCodeChallenge(using: verifier) }
        
        // Then
        assertNoError(when)
    }
    
    func testThatDerivatorProducesExpectedResults() {
        // Given
        let expectedResults = [
            "WCj6N2Fgl2YCuA5zZbJzCAeT6LFy1tJKgINAfs9HH4LC8futoIozrw5_OxWlxkxrgpTrdKttG2go--w5voQ4TtT8h8XNtMEukp5Ml74k8b6x68EVZf8UJRkc6EDP54au": "e3VN_G3VQWhXm4hG3kLiMb2rdZ-71OWQzRyAgyahkm0",
            "6UY1egvvH4vooAXQoyiWSoCkcScmHurEADdBj8Y0m0FeSuTHAOjh3MpEPqFDRC2YWBRuN3x8ZG2vO8bSCeT-XqE6QjBbwYjnLc6G7iJRpg-XhgBR6BXuFnXwkzXpz_iZ": "VjEiw3XwB9Y9Lr0HJxcyZyGunCkJ34Qqt9O1QCRR_ZU",
            "YUKoAwZOXHmPC6Ne53W1CVsz_0eiOIBHtJkxMIJMQD7ZgWAnv5jenaUar_5XQipBF0dMVoXPMCuZqCArcMr4GTMrmkDAI220DoX-zkT5Jbub6lgAKQXNqsdqvc6GgJep": "_VZ7xxdBVMZkAdNXc7kKIJr8-QO9qe5bcspw6n5bxkU",
            "kmdv7ZWEWlDkgPntzkN9I12vdMOreaT-NDrnCay1Ah0fuRzm1tcVtNETh7hp5fgmODmf2s5X0vfVavftsb8iWfLFmLWXf-KYICOFPDZCc2L2PFml5QfjuChz-s8jQVq6": "UufrwAlZD4McbUGePZPwP5B_A57Nav5XHUYLznPY9Xw",
            "hPRfxAgue53MlVQCdjs--qZrnVKtUhP4dhAl_YQOCq8WSreANoKsuMXfrZYU4iHNXmjxdD9r5-iN3BTmPyFYiMRimflbMuNRZ2XD1xk-w8J9GXqeR8uym7wybi_9k45O": "VUlQWKKH2Xm7mMgndC092SFM8veka3Bhepw0mNFwcEE"
        ]
        
        // When
        let hasUnexpectedResults = expectedResults.contains {
            try! derivator.deriveCodeChallenge(using: $0.key) != $0.value
        }
        
        // Then
        XCTAssertFalse(hasUnexpectedResults)
    }
    
    func testThatCodeChallengeMethodValueIsEqualToExpectedOne() {
        // Given
        let expectedResult = "S256"
        
        // When
        let result = derivator.codeChallengeMethod
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }

}
