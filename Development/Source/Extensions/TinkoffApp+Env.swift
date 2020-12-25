//
//  TinkoffApp+Env.swift
//  TinkoffID
//
//  Created by Dmitry on 21.12.2020.
//

import Foundation

extension TinkoffApp {
    /// URL-схема, используемая для определения установлено ли приложение Тинькофф
    var urlScheme: String {
        switch self {
        case .bank:
            return "tinkoffbank://"
        }
    }
    
    /// Базовый URL API
    var apiBaseUrl: String {
        switch self {
        case .bank:
            return "https://id.tinkoff.ru"
        }
    }
    
    /// Ссылка для проведения авторизации
    var authUrl: String {
        switch self {
        case .bank:
            return "https://tinkoff.ru/partner_auth"
        }
    }
}
