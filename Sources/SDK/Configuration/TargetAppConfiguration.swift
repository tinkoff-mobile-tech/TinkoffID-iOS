//
//  TargetAppConfiguration.swift
//  TinkoffID
//
//  Created by Dmitry on 20.01.2021.
//

import Foundation

/// Описывает приложение через которое выполняется авторизация
public protocol TargetAppConfiguration {
    /// URL-схема, используемая для определения установлено ли заданное приложение
    var urlScheme: String { get }
    
    /// Ссылка для проведения авторизации
    var authUrl: String { get }
}
