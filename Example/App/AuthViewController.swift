//
//  AuthViewController.swift
//  TinkoffIDExample
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

import SnapKit
import TinkoffID

final class AuthViewController: UIViewController {
    
    // MARK: - Dependencies
    private let authInitializer: ITinkoffAuthInitiator
    private let credentialsRefresher: ITinkoffCredentialsRefresher
    private let signOutInitializer: ITinkoffSignOutInitiator
    
    // MARK: - UI
    lazy var credentialsLabel = UILabel()
    lazy var signInButton = TinkoffIDButtonBuilder.build(.default)
    lazy var signOutButton = UIButton()
    lazy var refreshButton = UIButton()
    
    // MARK: - State
    private var credentials: TinkoffTokenPayload? {
        didSet {
            updateUserInterface()
        }
    }
    
    init(signInInitializer: ITinkoffAuthInitiator,
         credentialsRefresher: ITinkoffCredentialsRefresher,
         signOutInitializer: ITinkoffSignOutInitiator) {
        self.authInitializer = signInInitializer
        self.credentialsRefresher = credentialsRefresher
        self.signOutInitializer = signOutInitializer
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        updateUserInterface()
    }
    
    // MARK: - User interactions
    
    @objc
    private func signInButtonTapped() {
        authInitializer.startTinkoffAuth(handleSignInResult)
    }
    
    @objc
    private func signOutButtonTapped() {
        guard let token = credentials?.accessToken else { return }
        
        signOutInitializer.signOut(with: token,
                                   tokenTypeHint: .access,
                                   completion: handleSignOutResult(_:))
    }
    
    @objc
    private func refreshButtonTapped() {
        guard let refreshToken = credentials?.refreshToken else { return }
        
        credentialsRefresher.obtainTokenPayload(using: refreshToken, handleSignInResult)
    }
    
    // MARK: - Private
    
    private func setupUserInterface() {
        view.backgroundColor = .white
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        view.addSubview(signInButton)
        
        signOutButton.backgroundColor = UIColor(red: 220.0 / 255.0, green: 20.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
        signOutButton.layer.cornerRadius = 8
        signOutButton.setTitle("Выйти", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        refreshButton.backgroundColor = UIColor.lightGray
        refreshButton.layer.cornerRadius = 8
        refreshButton.setTitle("Обновить токены", for: .normal)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        view.addSubview(refreshButton)
        
        credentialsLabel.numberOfLines = .zero
        view.addSubview(credentialsLabel)
        
        credentialsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(signInButton)
            make.bottom.equalTo(refreshButton.snp.top).inset(-16)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.edges.equalTo(signInButton)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(signOutButton)
            make.bottom.equalTo(signOutButton.snp.top).offset(-16)
        }
    }
    
    private func updateUserInterface() {
        signOutButton.isHidden = (credentials == nil)
        refreshButton.isHidden = signOutButton.isHidden
        
        guard let credentials = credentials else {
            return credentialsLabel.text = nil
        }
        
        credentialsLabel.text = """
            🔑 Access token: \n\(credentials.accessToken)\n
            ⚙️ Refresh token: \n\(credentials.refreshToken ?? "none")\n
            🙎‍♂️ ID token: \n\(credentials.idToken)\n
            ⏱ Expires in \(Int(credentials.expirationTimeout)) seconds
            """
    }
    
    private func handleSignInResult(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            credentials = try result.get()
        } catch TinkoffAuthError.cancelledByUser {
            print("❌ Auth process cancelled by a user")
        } catch {
            print("❌ \(error)")
        }
    }
    
    private func handleSignOutResult(_ result: Result<Void, Error>) {
        do {
            _ = try result.get()
            
            credentials = nil
            
            print("✅ Signed out")
        } catch {
            print("❌ Sign out error: \(error)")
        }
    }
}
