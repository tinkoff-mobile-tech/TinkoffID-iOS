//
//  AuthWebViewBuilder.swift
//  TinkoffID
//
//  Created by Aleksandr Moskalyuk on 30.06.2023.
//

import Foundation

protocol IAuthWebViewBuilder {
    func build(with options: AppLaunchOptions) -> AuthWebView
}

final class AuthWebViewBuilder: IAuthWebViewBuilder {
    
    private var baseUrl: String
    private var pinningDelegate: PinningDelegate
    
    init(baseUrl: String,
         pinningDelegate: PinningDelegate) {
        self.baseUrl = baseUrl
        self.pinningDelegate = pinningDelegate
    }
    
    func build(with options: AppLaunchOptions) -> AuthWebView {
        return AuthWebView(pinningDelegate: pinningDelegate, options: options, baseUrl: baseUrl)
    }
}
