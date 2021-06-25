//
//  DebugTinkoffID.swift
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

final class DebugTinkoffID: ITinkoffID {
    
    enum Error: Swift.Error {
        case logoutForbidden
    }
    
    enum DebugAppResult: String {
        case success
        case failure
        case unavailable
        case cancelled
    }
    
    // Dependencies
    private let appLauncher: IDebugAppLauncher
    private let canRefreshTokens: Bool
    private let canLogout: Bool
    
    // State
    private var completion: SignInCompletion?
    
    init(appLauncher: IDebugAppLauncher, canRefreshTokens: Bool, canLogout: Bool) {
        self.appLauncher = appLauncher
        self.canRefreshTokens = canRefreshTokens
        self.canLogout = canLogout
    }
    
    var isTinkoffAuthAvailable: Bool {
        appLauncher.canLaunchDebugApp
    }
    
    func startTinkoffAuth(_ completion: @escaping SignInCompletion) {
        self.completion = completion
        
        appLauncher.launchDebugApp()
    }
    
    func handleCallbackUrl(_ url: URL) -> Bool {
        switch resolveDebugAppResult(url) {
        case .success:
            finish(with: .success(.stub))
        case .failure:
            finish(with: .failure(.failedToObtainToken))
        case .cancelled:
            finish(with: .failure(.cancelledByUser))
        case .unavailable:
            finish(with: .failure(.unavailable))
        default:
            return false
        }
        
        return true
    }
    
    func obtainTokenPayload(using refreshToken: String, _ completion: @escaping (Result<TinkoffTokenPayload, TinkoffAuthError>) -> Void) {
        DispatchQueue.main.async {
            if self.canRefreshTokens {
                completion(.success(.stub))
            } else {
                completion(.failure(.failedToRefreshCredentials))
            }
        }
    }
    
    func signOut(with token: String, tokenTypeHint: SignOutTokenTypeHint, completion: @escaping SignOutCompletion) {
        DispatchQueue.main.async {
            if self.canLogout {
                completion(.success({}()))
            } else {
                completion(.failure(Error.logoutForbidden))
            }
        }
    }
    
    // MARK: - Private
    
    private func resolveDebugAppResult(_ url: URL) -> DebugAppResult? {
        URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .queryItems?
            .first(where: { $0.name == .resultItemName })
            .flatMap { $0.value }
            .flatMap(DebugAppResult.init(rawValue: ))
    }
    
    private func finish(with result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        DispatchQueue.main.async {
            self.completion?(result)
            self.completion = nil
        }
    }
}

// MARK: - Private

private extension TinkoffTokenPayload {
    static var stub: TinkoffTokenPayload {
        TinkoffTokenPayload(
            accessToken: UUID().uuidString,
            refreshToken: UUID().uuidString,
            idToken: UUID().uuidString,
            expirationTimeout: TimeInterval(arc4random() % 10)
        )
    }
}

private extension String {
    static let resultItemName = "result"
}
