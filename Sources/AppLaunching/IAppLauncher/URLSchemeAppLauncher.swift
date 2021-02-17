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
