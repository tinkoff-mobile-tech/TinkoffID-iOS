//
//  MockedPKCECodeVerifierGenerator.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedPKCECodeVerifierGenerator: IPKCECodeVerifierGenerator {
    
    var stubbedCodeVerifierResult: String!
    
    func generateCodeVerifier() -> String {
        stubbedCodeVerifierResult
    }
}
