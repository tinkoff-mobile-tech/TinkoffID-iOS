//
//  MockedURLRouter.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedURLRouter: IURLRouter {
    var nextCanOpenUrlResult: Bool!
    var nextOpenResult: Bool!
    
    var lastCheckedUrl: URL?
    var lastOpenedURL: URL?
    
    func canOpenURL(_ url: URL) -> Bool {
        lastCheckedUrl = url
        
        defer {
            nextCanOpenUrlResult = nil
        }
        
        return nextCanOpenUrlResult
    }
    
    func open(_ url: URL) -> Bool {
        lastOpenedURL = url
        
        defer {
            nextOpenResult = nil
        }
        
        return nextOpenResult
    }
}
