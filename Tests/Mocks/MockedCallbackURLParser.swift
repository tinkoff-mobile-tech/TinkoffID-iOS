//
//  MockedCallbackURLParser.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedCallbackURLParser: ICallbackURLParser {
    var stubbedParseResult: CallbackURLParseResult?!
    var lastParseUrl: URL?
    
    func parse(_ url: URL) -> CallbackURLParseResult? {
        lastParseUrl = url
        
        return stubbedParseResult
    }
}
