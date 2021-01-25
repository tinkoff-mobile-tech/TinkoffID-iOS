//
//  IURLSchemeBuilder.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

/// Сборщик URL для запуска приложений
protocol IURLSchemeBuilder {
    
    /// Возвращает базовый URL
    var baseUrl: URL? { get }
    
    /// Собирает URL для запуска приложения с заданными опциями
    func buildUrlScheme(with options: AppLaunchOptions) throws -> URL
}
