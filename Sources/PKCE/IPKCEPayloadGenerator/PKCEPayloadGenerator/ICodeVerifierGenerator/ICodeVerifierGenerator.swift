//
//  CodeVerifierGenerator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

/// Генератор PKCE code verifier
protocol IPKCECodeVerifierGenerator {
    /// Возвращает PKCE code verifier
    func generateCodeVerifier() -> String
}
