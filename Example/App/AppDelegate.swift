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
    
    
    lazy var tinkoffId: ITinkoffID = {
        let clientId = "test-partner-mobile"
        let callbackUrl = "tinkoffauthpartner://"
        
        assert(!clientId.isEmpty, "Please specify an client ID")
        
        let factory = TinkoffIDFactory(
            clientId: clientId,
            callbackUrl: callbackUrl
        )
        
        return factory.build()
    }()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let authController = AuthViewController(
            signInInitializer: tinkoffId,
            credentialsRefresher: tinkoffId,
            signOutInitializer: tinkoffId
        )
        authController.tabBarItem = UITabBarItem(title: "Auth", image: nil, tag: 0)

        let tinkoffButtonsController = TinkoffButtonsViewController()
        tinkoffButtonsController.tabBarItem = UITabBarItem(title: "UI", image: nil, tag: 1)

        let tabBarController = UITabBarController()

        if #available(iOS 13.0, *) {
            authController.tabBarItem.image = UIImage(systemName: "person")
            tinkoffButtonsController.tabBarItem.image =  UIImage(systemName: "pencil")
        }
        tabBarController.viewControllers = [authController, tinkoffButtonsController]

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return tinkoffId.handleCallbackUrl(url)
    }
}
