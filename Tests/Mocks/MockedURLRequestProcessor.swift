//
//  MockedURLRequestProcessor.swift
//  TinkoffID
//
//  Created by Dmitry on 19.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedURLRequestProcessor: IURLRequestProcessor {
    
    var lastProcessRequest: URLRequest?
    var stubbedResult: Result<Data, Error>!
    
    func process(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        lastProcessRequest = request
        
        completion(stubbedResult)
    }
}
