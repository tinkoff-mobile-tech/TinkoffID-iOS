//
//  AuthProcess.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

/// Состояние процесса авторизации
struct AuthProcess {
    /// Данные для запуска приложения и инициации авторизации
    let appLaunchOptions: AppLaunchOptions
    /// Коллбек, передаваемый клиентом
    let completion: SignInCompletion
}
