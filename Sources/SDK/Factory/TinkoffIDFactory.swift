//
//  TinkoffIDBuilder.swift
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

/// Реализация фабрики `ITinkoffID` по умолчанию
public final class TinkoffIDFactory: ITinkoffIDFactory {
    
    // Dependencies
    private let builder: TinkoffIDBuilder
    
    // MARK: - Initialization
    
    /// Создаёт новый экземпляр класса
    ///
    /// - Parameters:
    ///   - clientId: Идентификатор приложения
    ///   - callbackUrl: Ссылка обратного вызова, по которой можно вернуться обратно в приложение
    ///   - app: Приложение Тинькофф, использующееся для входа
    ///   - environment: Окружение Тинькофф
    public convenience init(clientId: String,
                            callbackUrl: String,
                            app: TinkoffApp = .bank,
                            environment: TinkoffEnvironment = .production) {
        self.init(clientId: clientId,
                  callbackUrl: callbackUrl,
                  appConfiguration: app,
                  environmentConfiguration: environment)
    }
    
    /// Создаёт новый экземпляр класса
    ///
    /// - Parameters:
    ///   - clientId: Идентификатор приложения
    ///   - callbackUrl: Ссылка обратного вызова, по которой можно вернуться обратно в приложение
    ///   - appConfiguration: Конфигурация приложения, используемого для авторизации
    ///   - environmentConfiguration: Конфигурация окружения для работы SDK
    public init(clientId: String,
                callbackUrl: String,
                appConfiguration: TargetAppConfiguration,
                environmentConfiguration: EnvironmentConfiguration) {
        assert(!clientId.isEmpty, "Please specify some `clientId`")
        builder = TinkoffIDBuilder(clientId: clientId,
                                   callbackUrl: callbackUrl,
                                   appConfiguration: appConfiguration,
                                   environmentConfiguration: environmentConfiguration)
    }
    
    // MARK: - ITinkoffIDFactory
    
    public func build() -> ITinkoffID {
        builder.build()
    }
}
