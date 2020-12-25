//
//  AppLaunchOptions.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

/// Опции запуска приложения
struct AppLaunchOptions {
    /// Идентификатор авторизуемого клиента
    let clientId: String
    /// URL обратного вызова по которому будет осуществлен переход обратно в приложение
    let callbackUrl: String
    /// Набор PKCE параметров
    let payload: PKCECodePayload
}
