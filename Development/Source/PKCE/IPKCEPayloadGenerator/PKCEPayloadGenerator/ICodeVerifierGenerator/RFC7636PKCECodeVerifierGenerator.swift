//
//  RFC7636PKCECodeVerifierGenerator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

/// Реализация в соответствии с RFC 7636
/// https://tools.ietf.org/html/rfc7636#section-4.1
final class RFC7636PKCECodeVerifierGenerator: IPKCECodeVerifierGenerator {
    
    func generateCodeVerifier() -> String {
        var buffer = [UInt8](repeating: .zero, count: .codeVerifierLength)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        
        let result = Data(buffer)
            .base64EncodedString()
            .safeBase64
        
        guard result.count > .codeVerifierLength else { return result }
        
        let index = result.index(result.startIndex,
                                 offsetBy: .codeVerifierLength)
        
        return String(result[..<index])
    }
}

private extension Int {
    static let codeVerifierLength = 128
}
