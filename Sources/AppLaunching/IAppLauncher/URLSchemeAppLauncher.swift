//
//  URLSchemeAppLauncherTests.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

final class URLSchemeAppLauncher: IAppLauncher {
    
    enum Error: Swift.Error {
        case launchFailure
    }
    
    let builder: IURLSchemeBuilder
    let appUrlScheme: String
    let router: IURLRouter
    
    init(appUrlScheme: String, builder: IURLSchemeBuilder, router: IURLRouter) {
        self.builder = builder
        self.appUrlScheme = appUrlScheme
        self.router = router
    }
    
    var canLaunchApp: Bool {
        URL(string: appUrlScheme)
            .map(router.canOpenURL) ?? false
    }
    
    func launchApp(with options: AppLaunchOptions) throws {
        let appUrl = try builder.buildUrlScheme(with: options)
        
        if !router.open(appUrl) {
            // Не удалось запустить приложение
            throw Error.launchFailure
        }
    }
}
