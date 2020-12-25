//
//  ITinkoffID.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

public typealias SignInCompletion = (Result<TinkoffTokenPayload, TinkoffAuthError>) -> Void
public typealias SignOutCompletion = (Result<Void, Error>) -> Void

/// Объект, инициирующий процедуру входа с помощью Тинькофф
public protocol ITinkoffAuthInitiator {
    /// Возвращает `true` если есть возможность авторизоваться в приложении
    /// Если флаг `false`, то вызов `signIn` приведет к открытию App Store
    var isTinkoffAuthAvailable: Bool { get }
    
    /// Инициирует вход
    /// - Parameter completion: Блок с авторизационными данными или ошибкой. Всегда вызывается на главном потоке
    func startTinkoffAuth(_ completion: @escaping SignInCompletion)
}

/// Объект, продолжающий процесс входа после возврата в текущее приложение из приложения Тинькофф
public protocol ITinkoffAuthCallbackHandler {
    /// Пытается продолжить процесс входа с помощью URL, по которому был осуществлен возврат  в текущее приложение
    func handleCallbackUrl(_ url: URL) -> Bool
}

/// Объект, позволяющий обновить авторизационные данные
public protocol ITinkoffCredentialsRefresher {
    
    /// Обновляет авторизационные данные
    /// - Parameters:
    ///   - refreshToken: `Refresh token`, полученный с обновляемыми авторизационными данными
    ///   - completion: Блок с обновленными авторизационными данными или ошибкой. Всегда вызывается на главном потоке
    func obtainTokenPayload(using refreshToken: String,
                            _ completion: @escaping (Result<TinkoffTokenPayload, TinkoffAuthError>) -> Void)
}

/// Объект, инициирующий отзыв авторизации по `access` или `refresh` токену
public protocol ITinkoffSignOutInitiator {
    /// Отзывает авторизацию по `access` токену
    /// - Parameters:
    ///   - accessToken: Значение токена
    ///   - completion: Коллбек, который может содержать ошибку или ничего если ошибки не произошло. Всегда вызывается на главном потоке
    func signOut(accessToken: String, completion: @escaping SignOutCompletion)
    
    /// Отзывает авторизацию по `refresh` токену
    /// - Parameters:
    ///   - accessToken: Значение токена
    ///   - completion: Коллбек, который может содержать ошибку или ничего если ошибки не произошло. Всегда вызывается на главном потоке
    func signOut(refreshToken: String, completion: @escaping SignOutCompletion)
}

public protocol ITinkoffID: ITinkoffAuthInitiator, ITinkoffAuthCallbackHandler, ITinkoffCredentialsRefresher, ITinkoffSignOutInitiator {}
