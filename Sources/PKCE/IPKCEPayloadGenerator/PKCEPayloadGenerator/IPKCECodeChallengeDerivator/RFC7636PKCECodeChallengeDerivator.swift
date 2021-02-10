//
//  RFC7636PKCECodeChallengeDerivator.swift
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

import Foundation
import CommonCrypto

/// Реализация в соответствии с RFC 7636
/// https://tools.ietf.org/html/rfc7636#section-4.2
final class RFC7636PKCECodeChallengeDerivator: IPKCECodeChallengeDerivator {
    var codeChallengeMethod = "S256"
    
    enum Error: Swift.Error {
        case serializationError
    }
    
    func deriveCodeChallenge(using codeVerifier: String) throws -> String {
        guard let codeVerifierBytes = codeVerifier.data(using: .ascii) else {
            throw Error.serializationError
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
