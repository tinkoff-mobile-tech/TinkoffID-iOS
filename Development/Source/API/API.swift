//
//  API.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 31.03.2020.
//

import Foundation

final class API: IAPI {
    
    enum Error: Swift.Error {
        case unknown
    }
    
    private lazy var session = URLSession.shared
    private lazy var decoder = JSONDecoder()
    
    private let requestBuilder: IRequestBuilder
    
    init(requestBuilder: IRequestBuilder) {
        self.requestBuilder = requestBuilder
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
            
            session.dataTask(with: request) { data, response, error in
                self.handleResponse(data, response, error, completion)
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    private func handleResponse<T:Decodable>(_ data: Data?,
                                             _ response: URLResponse?,
                                             _ error: Swift.Error?,
                                             _ completion: @escaping (Result<T, Swift.Error>) -> Void) {
        guard let data = data else {
            return finish(completion, with: .failure(Error.unknown))
        }
        
        do {
            let credentials = try decoder.decode(T.self, from: data)
            
            finish(completion, with: .success(credentials))
        } catch {
            finish(completion, with: .failure(error))
        }
    }
    
    private func finish<T>(_ completion: @escaping (Result<T, Swift.Error>) -> Void, with result: Result<T, Swift.Error>) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
