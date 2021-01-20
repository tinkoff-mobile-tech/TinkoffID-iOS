//
//  PKCECodePayloadStubs.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import Foundation
@testable import TinkoffID

extension PKCECodePayload {
    static let stub = PKCECodePayload(verifier: "v",
                                      challenge: "c",
                                      challengeMethod: "cm")
}

extension AppLaunchOptions {
    static let stub = AppLaunchOptions(clientId: "ci",
                                       callbackUrl: "cu",
                                       payload: .stub)
}

extension TinkoffTokenPayload {
    static let stub = TinkoffTokenPayload(accessToken: "at",
                                          refreshToken: "rt",
                                          idToken: "it",
                                          expirationTimeout: .zero)
}

extension SignOutResponse {
    static let stub = SignOutResponse()
}

extension URLRequest {
    static let stub = URLRequest(url: URL(string: "stub://")!)
}

enum ErrorStub: Error {
    case foo
}
