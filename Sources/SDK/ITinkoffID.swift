//
//  ITinkoffID.swift
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
    
    /// Отзывает авторизацию по заданному токену
    /// - Parameters:
    ///   - token: Токен
    ///   - tokenTypeHint: Тип токена
    ///   - completion: Коллбек, который может содержать ошибку или ничего если ошибки не произошло. Всегда вызывается на главном потоке
    func signOut(with token: String, tokenTypeHint: SignOutTokenTypeHint, completion: @escaping SignOutCompletion)
}

public protocol ITinkoffID: ITinkoffAuthInitiator, ITinkoffAuthCallbackHandler, ITinkoffCredentialsRefresher, ITinkoffSignOutInitiator {}
