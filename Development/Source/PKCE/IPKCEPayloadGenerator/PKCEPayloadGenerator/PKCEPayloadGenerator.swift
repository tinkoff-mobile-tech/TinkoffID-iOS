//
//  PKCEPayloadGenerator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

final class PKCEPayloadGenerator: IPKCEPayloadGenerator {
    
    private let codeVerifierGenerator: IPKCECodeVerifierGenerator
    private let codeChallengeGenerator: IPKCECodeChallengeDerivator
    
    init(codeVerifierGenerator: IPKCECodeVerifierGenerator,
         codeChallengeGenerator: IPKCECodeChallengeDerivator) {
        self.codeVerifierGenerator = codeVerifierGenerator
        self.codeChallengeGenerator = codeChallengeGenerator
    }
    
    func generatePayload() -> PKCECodePayload {
        let codeVerifier = codeVerifierGenerator.generateCodeVerifier()
        let codeChallenge = codeChallengeGenerator.deriveCodeChallenge(using: codeVerifier)
        
        return PKCECodePayload(verifier: codeVerifier,
                               challenge: codeChallenge,
                               challengeMethod: codeChallengeGenerator.codeChallengeMethod)
    }
}
