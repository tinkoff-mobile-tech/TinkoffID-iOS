//
//  IDebugAppLauncher.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.06.2021.
//

import Foundation

/// Объект, запускающий приложение для отладки
protocol IDebugAppLauncher {
    
    /// Возвращает `true` если запуск приложения возможен
    var canLaunchDebugApp: Bool { get }
    
    /// Запускает приложение для отладки
    func launchDebugApp()
}
