//
//  CallbackURLParser.swift
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

final class CallbackURLParser: ICallbackURLParser {
    
    func parse(_ url: URL) -> CallbackURLParseResult? {
        let components = URLComponents(string: url.absoluteString)
        
        let flags: [String: CallbackURLParseResult] = [
            .cancelledItemName: .cancelled,
            .unavailableItemName: .unavailable
        ]
        
        // Поиск флагов, означающих заданный результат парсинга
        let result = flags.first { key, _ in
            components?.queryItems?.contains { $0.name == key } == true
        }
        
        if result != nil {
            return result?.value
        }
        
        return components?
            .queryItems?
            .lazy
            .compactMap { $0.name == .codeItemName && $0.value?.isEmpty == false ? .codeObtained($0.value!) : nil }
            .first
    }
}

private extension String {
    static let codeItemName = "code"
    static let cancelledItemName = "cancelled"
    static let unavailableItemName = "unavailable"
}
