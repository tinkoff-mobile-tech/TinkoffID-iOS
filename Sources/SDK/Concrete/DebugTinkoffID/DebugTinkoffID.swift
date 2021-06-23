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
    var isTinkoffAuthAvailable: Bool
    
    init(isTinkoffAuthAvailable: Bool) {
        self.isTinkoffAuthAvailable = isTinkoffAuthAvailable
    }
    
    func startTinkoffAuth(_ completion: @escaping SignInCompletion) {
        // TODO: implement
    }
    
    func handleCallbackUrl(_ url: URL) -> Bool {
        false // TODO: implement
    }
    
    func obtainTokenPayload(using refreshToken: String, _ completion: @escaping (Result<TinkoffTokenPayload, TinkoffAuthError>) -> Void) {
        // TODO: implement
    }
    
    func signOut(with token: String, tokenTypeHint: SignOutTokenTypeHint, completion: @escaping SignOutCompletion) {
        // TODO: implement
    }
}
