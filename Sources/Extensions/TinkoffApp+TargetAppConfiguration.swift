//
//  TinkoffApp+TargetAppConfiguration.swift
//  TinkoffID
//
//  Created by Dmitry on 21.12.2020.
//

import Foundation

extension TinkoffApp: TargetAppConfiguration {
    public var urlScheme: String {
        switch self {
        case .bank:
            return "tinkoffbank://"
        }
    }
    
    public var authUrl: String {
        switch self {
        case .bank:
            return "https://tinkoff.ru/partner_auth"
        }
    }
}
