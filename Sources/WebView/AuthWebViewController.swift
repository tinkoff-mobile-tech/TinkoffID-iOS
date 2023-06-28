//
//  AuthWebView.swift
//  Pods-TinkoffIDExample
//
//  Created by Aleksandr Moskalyuk on 20.06.2023.
//

import Foundation
import WebKit

final class AuthWebViewController: UIViewController {
    
    private let webView: WKWebView = WKWebView(frame: .zero)
    private let options: AppLaunchOptions
    
    init(options: AppLaunchOptions) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = UIScreen.main.bounds
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        do {
            let url = try buildWebViewUrlScheme(with: options)
            let request = URLRequest(url: url)
            webView.load(request)
        } catch {
            fatalError("Invalid URL provided to WebView")
        }
    }
    
    enum Error: Swift.Error {
        case unableToInitializeUrl
    }
    
    func buildWebViewUrlScheme(with options: AppLaunchOptions) throws -> URL {
        let params = [
            "client_id": options.clientId,
            "code_verifier": options.payload.verifier,
            "code_challenge_method": options.payload.challengeMethod,
            "code_challenge": options.payload.challenge,
            "redirect_uri": options.callbackUrl,
            "response_type": "code"//,
//            "prompt": "none"
        ]
        
        var components = URLComponents(string: "https://id-qa3.tcsbank.ru/auth/authorize")
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = components?.url else {
            throw Error.unableToInitializeUrl
        }
        
        return url
    }
}

extension AuthWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("navigationAction.request.url \(navigationAction.request.url)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let htmlQuery = "document.body.innerHTML"
        webView.evaluateJavaScript(htmlQuery) { jsonRaw, error in
            guard let jsonString = jsonRaw as? String else { return }
            if let r1 = jsonString.range(of: "{")?.lowerBound,
            let r2 = jsonString.range(of: "}")?.upperBound {
                let possibleJson = String(jsonString[r1..<r2])
                
                
                let data = Data(possibleJson.utf8)
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let code = json["code"] as? String {
                        print(code)
//                        let api = API()
//                            api.obtainCredentials(with: code,
//                                                  clientId: process.appLaunchOptions.clientId,
//                                                  codeVerifier: process.appLaunchOptions.payload.verifier,
//                                                  redirectUri: process.appLaunchOptions.callbackUrl) { result in
//                                let mappedResult = result.mapError { _ in
//                                    TinkoffAuthError.failedToObtainToken
//                                }
//                                                    
//                                process.completion(mappedResult)
//                            }
                    }
                    if let authId = json["authId"] as? String {
                        print(authId)
                    }
                    if let session_state = json["session_state"] as? String {
                        print(session_state)
                    }
//                    self.dismiss(animated: true)
                }
            }
        }
    }
}
