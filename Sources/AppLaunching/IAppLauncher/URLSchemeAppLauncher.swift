//
//  URLSchemeAppLauncherTests.swift
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

final class URLSchemeAppLauncher: IAppLauncher {
    
    enum Error: Swift.Error {
        case launchFailure
    }
    
    let builder: IURLSchemeBuilder
    let appUrlScheme: String
    let router: IURLRouter
//    let webViewBuilder: IAuthWebViewBuilder
    
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
        
        // add new logic somehow
        router.openWithFallback(appUrl) { didOpen in
            if !didOpen {
                self.openWebView(options: options)
            }
        }
        
//        if !router.open(appUrl) {
//            // Не удалось запустить приложение
//            throw Error.launchFailure
//        }
    }
    
    func openWebView(options: AppLaunchOptions) {
        let webVC = AuthWebViewController(options: options)
        UIApplication.getTopViewController()?.present(webVC, animated: true)
    }
}


extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
