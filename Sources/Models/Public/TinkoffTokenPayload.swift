//
//  TinkoffTokenPayload.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

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
