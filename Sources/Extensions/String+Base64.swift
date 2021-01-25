//
//  String+Base64.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

extension String {
    var safeBase64: String {
        var result = replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
        
        if result.count % 4 == .zero {
            while result.last == "=" {
                result.removeLast()
            }
        }
        
        return result
    }
}
