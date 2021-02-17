//
//  API.swift
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

final class API: IAPI {
    
    private lazy var decoder = JSONDecoder()
    
    let requestBuilder: IRequestBuilder
    let requestProcessor: IURLRequestProcessor
    let responseDispatcher: Dispatcher
    
    init(requestBuilder: IRequestBuilder, requestProcessor: IURLRequestProcessor, responseDispatcher: Dispatcher) {
        self.requestBuilder = requestBuilder
        self.requestProcessor = requestProcessor
        self.responseDispatcher = responseDispatcher
    }
    
    func obtainCredentials(with code: String,
                           clientId: String,
                           codeVerifier: String,
                           redirectUri: String,
                           completion: @escaping (Result<TinkoffTokenPayload, Swift.Error>) -> Void) {
        execute(try requestBuilder.buildTokenRequest(with: code,
                                                     clientId,
                                                     codeVerifier,
                                                     redirectUri),
                completion)
    }
    
    func obtainCredentials(with refreshToken: String,
                           clientId: String,
                           completion: @escaping (Result<TinkoffTokenPayload, Swift.Error>) -> Void) {
        execute(try requestBuilder.buildTokenRequest(with: refreshToken, clientId: clientId),
                completion)
    }
    
    func signOut(with token: String,
                 tokenTypeHint: SignOutTokenTypeHint,
                 clientId: String,
                 completion: @escaping (Result<SignOutResponse, Swift.Error>) -> Void) {
        execute(try requestBuilder.buildSignOutRequest(with: token, tokenTypeHint.rawValue, clientId),
                completion)
    }
    
    // MARK: - Private
    
    private func execute<T: Decodable>(_ requestClosure: @autoclosure () throws -> URLRequest,
                                       _ completion: @escaping (Result<T, Swift.Error>) -> Void) {
        do {
            let request = try requestClosure()
            
            requestProcessor.process(request) { response in
                let result = Result {
                    try self.decoder.decode(T.self, from: try response.get())
                }
                
                self.responseDispatcher.dispatch {
                    completion(result)
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
