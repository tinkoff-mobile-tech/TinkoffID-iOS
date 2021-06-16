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
    
    lazy var factory: ITinkoffIDFactory = {
        TinkoffIDFactory(clientId: Constant.clientId,
                         callbackUrl: Constant.callbackUrl,
                         app: .bank)
    }()
    lazy var tinkoffId = factory.build()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let authController = AuthViewController(signInInitializer: tinkoffId,
                                                credentialsRefresher: tinkoffId,
                                                signOutInitializer: tinkoffId)
        
        window?.rootViewController = authController
        window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        tinkoffId.handleCallbackUrl(url)
    }
}

struct Constant {
    /// Идентификатор приложения
    /// TODO: Указать
    static let clientId = ""
    /// Ссылка обратного вызова, по которой можно вернуться обратно в приложение
    static let callbackUrl = "tinkoffauthpartner://"
}
