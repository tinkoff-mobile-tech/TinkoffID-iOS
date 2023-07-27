//
//  MockedURLRouter.swift
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

    func openWithFallback(_ url: URL, completion: @escaping ((Bool) -> Void)) -> Bool {
        lastOpenedURL = url

        defer {
            nextOpenResult = nil
        }

        completion(nextOpenResult)

        return nextOpenResult
    }
}
