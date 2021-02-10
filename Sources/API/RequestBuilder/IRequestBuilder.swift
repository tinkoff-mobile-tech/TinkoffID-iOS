//
//  IRequestBuilder.swift
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

/// Конструктор запросов
protocol IRequestBuilder {
    
    /// Возвращает запрос на получение токена
    /// - Parameters:
    ///   - code: Код, полученный от приложения Тинькофф
    ///   - clientId: Идентификатор авторизуемого приложения
    ///   - codeVerifier: Строка, сгенерированная в соответствии с форматом PKCE, служащая для предотвращения компрометации кода
    ///   - redirectUri: URI обратного вызова
    func buildTokenRequest(with code: String,
                           _ clientId: String,
                           _ codeVerifier: String,
                           _ redirectUri: String) throws -> URLRequest
    
    /// Возвращает запрос на обновление токена
    /// - Parameters:
    ///   - refreshToken: `Refresh token`, полученный с обновляемыми авторизационными данными
    ///   - clientId: Идентификатор авторизуемого приложения
    func buildTokenRequest(with refreshToken: String, clientId: String) throws -> URLRequest
    
    /// Возвращает запрос на инвалидацию токена
    /// - Parameters:
    ///   - token: Значение токена
    ///   - tokenTypeHint: Тип токена
    ///   - clientId: Идентификатор авторизуемого приложения
    func buildSignOutRequest(with token: String,
                             _ tokenTypeHint: String,
                             _ clientId: String) throws -> URLRequest
}
