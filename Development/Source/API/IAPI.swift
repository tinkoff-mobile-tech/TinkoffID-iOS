//
//  IAPI.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 31.03.2020.
//

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
