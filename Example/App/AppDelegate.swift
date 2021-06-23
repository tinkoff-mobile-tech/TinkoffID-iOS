//
//  AppDelegate.swift
//  TinkoffIDExample
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

import UIKit
import TinkoffID

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var window = UIWindow(frame: UIScreen.main.bounds) as UIWindow?
    
    let factoryImplementation = TinkoffIDFactoryImplementation.default(
        /// Идентификатор приложения
        /// TODO: Указать
        clientId: "",
        /// Ссылка обратного вызова, по которой можно вернуться обратно в приложение
        callbackUrl: "tinkoffauthpartner://"
    )
    
    lazy var tinkoffId: ITinkoffID = {
        let factory: ITinkoffIDFactory
        
        switch factoryImplementation {
        case let .default(clientId, callbackUrl):
            assert(!clientId.isEmpty, "Please specify some `clientId`")
            
            factory = TinkoffIDFactory(
                clientId: clientId,
                callbackUrl: callbackUrl,
                app: .bank
            )
        case let .debug(configuration):
            factory = DebugTinkoffIDFactory(configuration: configuration)
        }
        
        return factory.build()
    }()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let authController = AuthViewController(
            signInInitializer: tinkoffId,
            credentialsRefresher: tinkoffId,
            signOutInitializer: tinkoffId
        )
        
        window?.rootViewController = authController
        window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        tinkoffId.handleCallbackUrl(url)
    }
}

enum TinkoffIDFactoryImplementation {
    case `default`(clientId: String, callbackUrl: String)
    case debug(configuration: DebugTinkoffIDFactory.Configuration)
}
