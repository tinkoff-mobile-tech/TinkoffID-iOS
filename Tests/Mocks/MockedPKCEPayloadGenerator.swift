//
//  MockedPKCEPayloadGenerator.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedPKCEPayloadGenerator: IPKCEPayloadGenerator {
    var stubbedPayload: PKCECodePayload!
    var stubbedError: Error?
    
    func generatePayload() throws -> PKCECodePayload {
        if let error = stubbedError {
            throw error
        }
        
        return stubbedPayload
    }
}
