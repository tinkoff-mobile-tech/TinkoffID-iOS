//
//  IAppLauncher.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

/// Объект, запускающий приложение  для авторизации
protocol IAppLauncher {
    
    /// Возвращает `true` если запуск приложения возможен
    var canLaunchApp: Bool { get }
    
    /// Запускает приложение с заданными опциями
    func launchApp(with options: AppLaunchOptions) throws
}
