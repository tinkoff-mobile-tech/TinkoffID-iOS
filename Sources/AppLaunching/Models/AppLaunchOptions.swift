//
//  AppLaunchOptions.swift
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

/// Опции запуска приложения
struct AppLaunchOptions: Equatable {
    /// Идентификатор авторизуемого клиента
    let clientId: String
    /// URL обратного вызова по которому будет осуществлен переход обратно в приложение
    let callbackUrl: String
    /// Набор PKCE параметров
    let payload: PKCECodePayload
}
