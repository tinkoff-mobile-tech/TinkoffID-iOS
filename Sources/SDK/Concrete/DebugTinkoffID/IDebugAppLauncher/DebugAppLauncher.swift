//
//  DebugAppLauncher.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.06.2021.
//

import Foundation

final class DebugAppLauncher: IDebugAppLauncher {
    private let router: IURLRouter
    private let urlScheme: String
    
    private var debugAppUrl: URL? {
        URL(string: urlScheme)
    }
    
    init(urlScheme: String, router: IURLRouter) {
        self.urlScheme = urlScheme
        self.router = router
    }
    
    var canLaunchDebugApp: Bool {
        debugAppUrl.map(router.canOpenURL(_:)) ?? false
    }
    
    func launchDebugApp() {
        _ = debugAppUrl.map(router.open(_:))
    }
}
