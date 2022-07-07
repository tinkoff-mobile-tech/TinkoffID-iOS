//
//  TinkoffIDButtonColorStyle+Extension.swift
//  TinkoffID
//
//  Created by Margarita Shishkina on 13.07.2022.
//

import Foundation

extension TinkoffIDButtonColorStyle {
    /// Возвращает цвет фона для соответствующего состояния
    /// - Parameter state: Состояние кнопки
    func backgroundColorFor(state: UIControl.State) -> UIColor {
        switch state {
        case .highlighted:
            return highlightedBackgroundColor
        default:
            return backgroundColor
        }
    }

    /// цвет текста для соответствующего состояния
    var titleColor: UIColor {
        switch self {
        case .alternativeDark:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .alternativeLight:
            return UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        case .default:
            return UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        }
    }

    /// Цвет поля кэшбэка
    var badgeFieldColor: UIColor {
        switch self {
        case .alternativeDark:
            return UIColor(red: 61 / 255, green: 61 / 255, blue: 61 / 255, alpha: 1)
        case .alternativeLight:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .default:
            return UIColor(red: 1, green: 238 / 255, blue: 149 / 255, alpha: 1)
        }
    }

    /// Цвет текста кэшбэка
    var badgeTextColor: UIColor {
        switch self {
        case .alternativeDark:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .alternativeLight:
            return UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        case .default:
            return UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        }
    }

    private var highlightedBackgroundColor: UIColor {
        switch self {
        case .alternativeDark:
            return UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        case .alternativeLight:
            return UIColor(red: 206 / 255, green: 206 / 255, blue: 207 / 255, alpha: 1)
        case .default:
            return UIColor(red: 250 / 255, green: 182 / 255, blue: 25 / 255, alpha: 1)
        }
    }

    private var backgroundColor: UIColor {
        switch self {
        case .alternativeDark:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .alternativeLight:
            return UIColor(red: 245 / 255, green: 245 / 255, blue: 246 / 255, alpha: 1)
        case .default:
            return UIColor(red: 255 / 255, green: 221 / 255, blue: 45 / 255, alpha: 1)
        }
    }
}
