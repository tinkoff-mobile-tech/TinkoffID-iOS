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
import UIKit

/// Реализация фабрики `ITinkoffID` по умолчанию
public final class TinkoffIDFactory: ITinkoffIDFactory {
    
    // Dependencies
    private let clientId: String
    private let callbackUrl: String
    private let appConfiguration: TargetAppConfiguration
    private let environmentConfiguration: EnvironmentConfiguration
    
    // MARK: - Initialization
    
    /// Создаёт новый экземпляр класса
    ///
    /// - Parameters:
    ///   - clientId: Идентификатор приложения
    ///   - callbackUrl: Ссылка обратного вызова, по которой можно вернуться обратно в приложение
    ///   - app: Приложение Тинькофф, использующееся для входа
    ///   - environment: Окружение Тинькофф
    public convenience init(
        clientId: String,
        callbackUrl: String,
        app: TinkoffApp = .bank,
        environment: TinkoffEnvironment = .production
    ) {
        self.init(
            clientId: clientId,
            callbackUrl: callbackUrl,
            appConfiguration: app,
            environmentConfiguration: environment
        )
    }
    
    /// Создаёт новый экземпляр класса
    ///
    /// - Parameters:
    ///   - clientId: Идентификатор приложения
    ///   - callbackUrl: Ссылка обратного вызова, по которой можно вернуться обратно в приложение
    ///   - appConfiguration: Конфигурация приложения, используемого для авторизации
    ///   - environmentConfiguration: Конфигурация окружения для работы SDK
    public init(
        clientId: String,
        callbackUrl: String,
        appConfiguration: TargetAppConfiguration,
        environmentConfiguration: EnvironmentConfiguration
    ) {
        self.clientId = clientId
        self.callbackUrl = callbackUrl
        self.environmentConfiguration = environmentConfiguration
        self.appConfiguration = appConfiguration
    }
    
    // MARK: - ITinkoffIDFactory
    
    public func build() -> ITinkoffID {
        let urlSchemeBuilder = URLSchemeBuilder(baseUrlString: appConfiguration.authUrl)
        let appLauncher = URLSchemeAppLauncher(
            appUrlScheme: appConfiguration.urlScheme,
            builder: urlSchemeBuilder,
            router: UIApplication.shared
        )
        
        let requestBuilder = RequestBuilder(baseUrl: environmentConfiguration.apiBaseUrl)
        let api = API(
            requestBuilder: requestBuilder,
            requestProcessor: URLSession.shared,
            responseDispatcher: DispatchQueue.main
        )
        
        let codeVerifierGenerator = RFC7636PKCECodeVerifierGenerator()
        let codeChallengeDerivator = RFC7636PKCECodeChallengeDerivator()
        
        let payloadGenerator = PKCEPayloadGenerator(
            codeVerifierGenerator: codeVerifierGenerator,
            codeChallengeDerivator: codeChallengeDerivator
        )
        
        let callbackUrlParser = CallbackURLParser()
        
        return TinkoffID(
            payloadGenerator: payloadGenerator,
            appLauncher: appLauncher,
            callbackUrlParser: callbackUrlParser,
            api: api,
            clientId: clientId,
            callbackUrl: callbackUrl
        )
    }
}
