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
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func build(with options: AppLaunchOptions) -> AuthWebView {
        return AuthWebView(options: options, baseUrl: baseUrl)
    }
}
