//
//  IAPI.swift
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

/// Объект, взаимодействующий с авторизационным API
protocol IAPI {
    
    /// Получает авторизационные данные
    /// - Parameters:
    ///   - code: Код, полученный от приложения Тинькофф
    ///   - clientId: Идентификатор авторизуемого приложения
    ///   - codeVerifier: Строка, сгенерированная в соответствии с форматом PKCE, служащая для предотвращения компрометации кода
    ///   - redirectUri: URI обратного вызова
    ///   - completion: Коллбек
    func obtainCredentials(with code: String,
                           clientId: String,
                           codeVerifier: String,
                           redirectUri: String,
                           completion: @escaping (Result<TinkoffTokenPayload, Error>) -> Void)
    
    /// Обновляет имеющиеся авторизационные данные
    /// - Parameters:
    ///   - refreshToken: `Refresh token`, полученный с обновляемыми авторизационными данными
    ///   - clientId: Идентификатор авторизуемого приложения
    ///   - completion: Коллбек
    func obtainCredentials(with refreshToken: String,
                           clientId: String,
                           completion: @escaping (Result<TinkoffTokenPayload, Error>) -> Void)
    
    /// Выполняет инвалидацию токена
    /// - Parameters:
    ///   - token: Значение токена
    ///   - tokenTypeHint: Тип токена
    ///   - clientId: Идентификатор авторизуемого приложения
    ///   - completion: Коллбек
    func signOut(with token: String,
                 tokenTypeHint: SignOutTokenTypeHint,
                 clientId: String,
                 completion: @escaping (Result<SignOutResponse, Error>) -> Void)
}
