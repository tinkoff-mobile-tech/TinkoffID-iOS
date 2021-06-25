//
//  AppDelegate.swift
//  TinkoffID Debug
//
//  Created by Dmitry Overchuk on 24.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let rootViewController = app.keyWindow?.rootViewController
        
        guard rootViewController?.presentedViewController == nil else { return true }
        guard let interactor = DebugInteractor(url: url) else { return true }
        
        let controller = DebugViewController(output: interactor)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isModalInPresentation = true
        
        rootViewController?.present(navigationController, animated: true, completion: nil)
        
        return true
    }
}

