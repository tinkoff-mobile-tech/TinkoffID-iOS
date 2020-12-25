//
//  IPKCECodeChallengeDerivator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

/// Объект, выводящий `code challenge` в соответствии со спецификацией `PKCE`
protocol IPKCECodeChallengeDerivator {
    
    /// Выводит  `code challenge `используя заданый `code verifier`
    func deriveCodeChallenge(using codeVerifier: String) -> String
    
    /// Возвращает метод получения `code challenge` (например `plain`, `S256`, и т.д..)
    var codeChallengeMethod: String { get }
}
