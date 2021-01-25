//
//  API.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 31.03.2020.
//

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
