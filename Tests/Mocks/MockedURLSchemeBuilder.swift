//
//  MockedURLSchemeBuilder.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedURLSchemeBuilder: IURLSchemeBuilder {
    var baseUrl: URL?
    
    var nextBuildUrlSchemeResult: URL!
    var lastOptions: AppLaunchOptions?
    
    func buildUrlScheme(with options: AppLaunchOptions) throws -> URL {
        lastOptions = options
        
        defer {
            nextBuildUrlSchemeResult = nil
        }
        
        return nextBuildUrlSchemeResult
    }
}
