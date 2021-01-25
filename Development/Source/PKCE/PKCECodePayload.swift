//
//  PKCECodePayload.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

/// Набор PKCE параметров в соответствии с  https://tools.ietf.org/html/rfc7636#page-8
struct PKCECodePayload: Equatable {
    let verifier: String
    let challenge: String
    let challengeMethod: String
}
