//
//  PKCEPayloadGenerator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

final class PKCEPayloadGenerator: IPKCEPayloadGenerator {
    
    let codeVerifierGenerator: IPKCECodeVerifierGenerator
    let codeChallengeDerivator: IPKCECodeChallengeDerivator
    
    init(codeVerifierGenerator: IPKCECodeVerifierGenerator,
         codeChallengeDerivator: IPKCECodeChallengeDerivator) {
        self.codeVerifierGenerator = codeVerifierGenerator
        self.codeChallengeDerivator = codeChallengeDerivator
    }
    
    func generatePayload() throws -> PKCECodePayload {
        let codeVerifier = codeVerifierGenerator.generateCodeVerifier()
        let codeChallenge = try codeChallengeDerivator.deriveCodeChallenge(using: codeVerifier)
        
        return PKCECodePayload(verifier: codeVerifier,
                               challenge: codeChallenge,
                               challengeMethod: codeChallengeDerivator.codeChallengeMethod)
    }
}
