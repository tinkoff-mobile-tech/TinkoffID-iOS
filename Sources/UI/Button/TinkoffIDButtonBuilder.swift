//
//  TinkoffIDButtonBuilder.swift
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

import UIKit

/// Конфигурация кнопки
public struct TinkoffIDButtonConfiguration {
    /// Стиль кнопки
    let colorStyle: TinkoffIDButtonColorStyle
    /// Размер
    let size: TinkoffIDButtonSize
    /// Радиус скругления
    let cornerRadius: CGFloat
    /// Шрифт
    let font: UIFont

    public init(
        colorStyle: TinkoffIDButtonColorStyle = .default,
        size: TinkoffIDButtonSize = .medium,
        cornerRadius: CGFloat = 8,
        font: UIFont = UIFont.systemFont(ofSize: 15)
    ) {
        self.colorStyle = colorStyle
        self.size = size
        self.cornerRadius = cornerRadius
        self.font = font
    }
}

/// Размер кнопки входа
public enum TinkoffIDButtonSize {
    /// Размер от 30 до 40, по дефолту 30
    case small
    /// Размер от 40 до 60, по дефолту 40
    case medium
    /// Размер от 60, по дефолту 60
    case large

    init(height: CGFloat) {
        if height < 40 {
            self = .small
        } else if height < 60 {
            self = .medium
        } else {
            self = .large
        }
    }
}

/// Цветовой стиль кнопки входа
public enum TinkoffIDButtonColorStyle {
    /// Стандартная желтая тема
    case `default`
    /// Светлая тема
    case alternativeLight
    /// Темная тема
    case alternativeDark
}

/// Сборщик кнопки входа через Тинькофф
public final class TinkoffIDButtonBuilder {
    
    /// Создает прямоугольную кнопку входа через Тинькофф
    /// - Parameter configuration: Конфигурация кнопки
    /// - Parameter title: Текст кнопки
    /// - Parameter badge: Дополнительный текст на бейдже
    /// - Returns: Контрол кнопки
    public static func build(
        configuration: TinkoffIDButtonConfiguration = TinkoffIDButtonConfiguration(),
        title: String? = nil,
        badge: String? = nil
    ) -> UIControl {
        TinkoffIDButton(configuration: configuration, title: title, badge: badge)
    }
    /// Создает круглую кнопку входа через Тинькофф
    /// - Parameter colorStyle: Цветовая тема кнопки
    /// - Returns: Контрол кнопки
    public static func buildCompact(colorStyle: TinkoffIDButtonColorStyle = .default) -> UIControl {
        TinkoffIDCompactButton(colorStyle: colorStyle)
    }
}
