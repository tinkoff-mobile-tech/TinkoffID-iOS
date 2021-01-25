//
//  Environment+EnvironmentConfiguration.swift
//  TinkoffID
//
//  Created by Dmitry on 20.01.2021.
//

import Foundation

extension TinkoffEnvironment: EnvironmentConfiguration {
    public var apiBaseUrl: String {
        switch self {
        case .production:
            return "https://id.tinkoff.ru"
        }
    }
}
