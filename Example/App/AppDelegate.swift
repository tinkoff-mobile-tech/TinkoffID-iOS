//
//  AppDelegate.swift
//  TinkoffIDExample
//
//  Created by Dmitry Overchuk on 01.04.2020.
//

import UIKit
import TinkoffID

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var window = UIWindow(frame: UIScreen.main.bounds) as UIWindow?
    
    lazy var factory = TinkoffIDBuilder(clientId: Constant.clientId,
                                        callbackUrl: Constant.callbackUrl,
                                        app: .bank)
    lazy var tinkoffId = factory.build()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        assert(!Constant.clientId.isEmpty, "Please specify some `clientId`")
        
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
