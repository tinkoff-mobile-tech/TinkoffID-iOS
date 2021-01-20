//
//  MockedPKCECodeChallengeDerivator.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedPKCECodeChallengeDerivator: IPKCECodeChallengeDerivator {
    
    var stubbedCodeChallengeMethod: String!
    var stubbedDeriveCodeChallengeResult: String!
    
    var lastDeriveCodeChallengeCodeVerifierParam: String?
    
    var codeChallengeMethod: String {
        stubbedCodeChallengeMethod
    }
    
    func deriveCodeChallenge(using codeVerifier: String) throws -> String {
        lastDeriveCodeChallengeCodeVerifierParam = codeVerifier
        
        return stubbedDeriveCodeChallengeResult
    }
}
