//
//  EnvironmentConfiguration.swift
//  TinkoffID
//
//  Created by Dmitry on 20.01.2021.
//

import Foundation

/// Описывает окружение для работы SDK
public protocol EnvironmentConfiguration {
    /// Базовый URL API
    var apiBaseUrl: String { get }
}
