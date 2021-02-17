//
//  RFC7636PKCECodeVerifierGenerator.swift
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
