//
//  CallbackURLParser.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 30.03.2020.
//

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
