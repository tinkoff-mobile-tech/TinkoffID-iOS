//
//  TinkoffTokenPayload.swift
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

/// Авторизационные данные
public struct TinkoffTokenPayload: Equatable {
    /// Токен для обращения к API Тинькофф
    public let accessToken: String
    /// Токен, необходимый для получения нового `accessToken`
    public let refreshToken: String?
    /// Идентификатор пользователя в формате JWT
    public let idToken: String
    /// Время. через которое `accessToken` станет неактуальным и нужно будет получить новый с помощью `refreshToken`
    public let expirationTimeout: TimeInterval
}

extension TinkoffTokenPayload: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case expirationTimeout = "expires_in"
    }
}
