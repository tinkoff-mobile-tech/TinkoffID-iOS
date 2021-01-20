//
//  IURLRequestProcessor.swift
//  TinkoffID
//
//  Created by Dmitry on 19.01.2021.
//

import Foundation

/// Объект, выполняющий сетевые запросы
protocol IURLRequestProcessor {
    
    /// Выполняет сетевой запрос
    /// - Parameters:
    ///   - request: Запрос
    ///   - completion: Коллбек с результатом выполнения
    func process(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

extension URLSession: IURLRequestProcessor {
    
    enum Error: Swift.Error {
        case unknown
    }
    
    func process(_ request: URLRequest, completion: @escaping (Result<Data, Swift.Error>) -> Void) {
        dataTask(with: request) { data, response, error in
            guard let data = data else {
                return completion(.failure(error ?? Error.unknown))
            }
            
            completion(.success(data))
        }.resume()
    }
}
