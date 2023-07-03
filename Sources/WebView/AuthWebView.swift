//
//  AuthWebView.swift
//  Pods-TinkoffIDExample
//
//  Created by Aleksandr Moskalyuk on 20.06.2023.
//

import Foundation
import WebKit

protocol IAuthWebViewDelegate: AnyObject {
    func authWebView(_ webView: AuthWebView, didOpen url: URL)
}

final class AuthWebView: UIViewController {
    
    weak var delegate: IAuthWebViewDelegate?
    
    private let webView: WKWebView = WKWebView(frame: .zero)
    private let options: AppLaunchOptions
    private var baseUrl: String
    
    init(options: AppLaunchOptions,
         baseUrl: String) {
        self.options = options
        self.baseUrl = baseUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Bundle.resourcesBundle?
            .imageNamed("reload"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(reloadButtonClicked))
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        
        // TODO: Почему прозрачный?
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        loadWebView()
    }
    
    func loadWebView() {
        do {
            let url = try buildWebViewURL(with: options)
            let request = URLRequest(url: url)
            webView.load(request)
        } catch {
            fatalError("Invalid URL provided to WebView")
        }
    }
    
    func buildWebViewURL(with options: AppLaunchOptions) throws -> URL {
        let params = [
            "client_id": options.clientId,
            "code_verifier": options.payload.verifier,
            "code_challenge_method": options.payload.challengeMethod,
            "code_challenge": options.payload.challenge,
            "redirect_uri": options.callbackUrl,
            "response_type": "code",
            "response_mode": "query"
        ]
        
        var components = URLComponents(string: "\(baseUrl)/auth/authorize")
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        enum Error: Swift.Error {
            case unableToInitializeUrl
        }
        
        guard let url = components?.url else {
            throw Error.unableToInitializeUrl
        }
        
        return url
    }
    
    func open() {
        let navigationController = UINavigationController(rootViewController: self)
        UIApplication.getTopViewController()?.present(navigationController, animated: true)
        
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func reloadButtonClicked() {
        loadWebView()
    }
}

extension AuthWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        
        if url.absoluteString == "https://www.tinkoff.ru/" {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
        delegate?.authWebView(self, didOpen: url)
    }
}

// MARK: - TopViewController

private extension UIApplication {

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
