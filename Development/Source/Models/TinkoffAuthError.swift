//
//  TinkoffAuthError.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

/// Ошибка авторизации
public enum TinkoffAuthError: Error {
    // Не удалось запустить приложение по какой-либо причине
    case failedToLaunchApp
    // Пользователь отменил процесс авторизации
    case cancelledByUser
    // Авторизация сторонних приложений недоступна пользователю Тинькофф
    case unavailable
    // Не удалось завершить авторизацию после возврата из приложения
    case failedToObtainToken
    // Не удалось обновить токены
    case failedToRefreshCredentials
}
