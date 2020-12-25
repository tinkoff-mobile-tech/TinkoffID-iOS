//
//  RFC7636PKCECodeChallengeDerivator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation
import CommonCrypto

/// Реализация в соответствии с RFC 7636
/// https://tools.ietf.org/html/rfc7636#section-4.2
final class RFC7636PKCECodeChallengeDerivator: IPKCECodeChallengeDerivator {
    var codeChallengeMethod = "S256"
    
    func deriveCodeChallenge(using codeVerifier: String) -> String {
        guard let codeVerifierBytes = codeVerifier.data(using: .ascii) else {
            assertionFailure("Failed to serialize codeVerifier")
            return String()
        }
        
        var buffer = [UInt8](repeating: .zero, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        codeVerifierBytes.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(codeVerifierBytes.count), &buffer)
        }
        
        return Data(buffer)
            .base64EncodedString()
            .safeBase64
    }
}
