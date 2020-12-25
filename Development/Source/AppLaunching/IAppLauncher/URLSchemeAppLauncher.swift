//
//  URLSchemeAppLauncher.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 25.03.2020.
//

import Foundation

final class URLSchemeAppLauncher: IAppLauncher {
    
    enum Error: Swift.Error {
        case launchFailure
    }
    
    private let app = UIApplication.shared
    private let builder: IURLSchemeBuilder
    private let appUrlScheme: String
    
    init(builder: IURLSchemeBuilder, appUrlScheme: String) {
        self.builder = builder
        self.appUrlScheme = appUrlScheme
    }
    
    var canLaunchApp: Bool {
        app.canOpenURL(
            URL(string: appUrlScheme)
        )
    }
    
    func launchApp(with options: AppLaunchOptions) throws {
        let appUrl = try builder.buildUrlScheme(with: options)
        
        if app.canOpenURL(appUrl) {
            // Открывается приложение
            app.open(appUrl)
        } else {
            // Не удалось запустить приложение
            throw Error.launchFailure
        }
    }
}

private extension UIApplication {
    
    func canOpenURL(_ url: URL?) -> Bool {
        guard let url = url else { return false }
        
        return canOpenURL(url)
    }
    
    func open(_ url: URL?) {
        guard let url = url else { return }
        
        open(url, options: [:], completionHandler: nil)
    }
}
