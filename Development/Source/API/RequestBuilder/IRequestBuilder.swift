//
//  IRequestBuilder.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 31.03.2020.
//

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
