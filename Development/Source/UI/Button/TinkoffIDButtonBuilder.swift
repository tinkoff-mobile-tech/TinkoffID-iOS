//
//  TinkoffIDButtonBuilder.swift
//  TinkoffID
//
//  Created by Dmitry on 18.12.2020.
//

import Foundation

/// Стиль кнопки входа
public enum TinkoffIDButtonStyle {
    /// Стандартная желтая кнопка высотой 56 точек
    case `default`
    /// Желтая кнопка высотой 40 точек
    case compact
}

/// Сборщик кнопки входа через Тинькофф
public final class TinkoffIDButtonBuilder {
    
    /// Создает кнопку входа через Тинькофф
    /// - Parameter style: Стиль кнопки
    /// - Returns: Контрол кнопки
    public static func build(_ style: TinkoffIDButtonStyle) -> UIControl {
        TinkoffIDButton(style)
    }
}
