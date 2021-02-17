//
//  PKCECodePayloadStubs.swift
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
