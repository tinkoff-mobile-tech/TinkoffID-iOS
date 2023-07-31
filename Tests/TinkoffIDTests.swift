//
//  TinkoffIDTests.swift
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

import XCTest
@testable import TinkoffID

class TinkoffIDTests: XCTestCase {
    private var sdk: TinkoffID!
    private var payloadGenerator: MockedPKCEPayloadGenerator!
    private var appLauncher: MockedAppLauncher!
    private var callbackParser: MockedCallbackURLParser!
    private var api: MockedAPI!
    private var authWebView: MockedWebView!
    private var authWebViewBuilder: MockedWebViewBuilder!

    private let clientId = "some_client"
    private let callbackUrl = "nowhere://"

    override func setUpWithError() throws {
        payloadGenerator = MockedPKCEPayloadGenerator()
        appLauncher = MockedAppLauncher()
        callbackParser = MockedCallbackURLParser()
        api = MockedAPI()
        authWebView = MockedWebView()
        authWebViewBuilder = MockedWebViewBuilder()
        
        sdk = TinkoffID(payloadGenerator: payloadGenerator,
                        appLauncher: appLauncher,
                        callbackUrlParser: callbackParser,
                        api: api,
                        authWebViewBuilder: authWebViewBuilder,
                        clientId: clientId,
                        callbackUrl: callbackUrl,
                        shouldFallbackToWebView: false)
    }
    
    func testThatIsTinkoffAuthAvailableValueDependsOnAppLauncher() {
        // Given
        appLauncher.stubbedCanLaunchApp = true
        
        // When
        let result = sdk.isTinkoffAuthAvailable
        
        // Then
        XCTAssertEqual(result, appLauncher.canLaunchApp)
    }
    
    func testThatAppLauncherWillLaunchAppWithCorrectOptionsWhenStartingTinkoffAuth() {
        // Given
        payloadGenerator.stubbedPayload = .stub
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        let expectedOptions = AppLaunchOptions(clientId: clientId,
                                               callbackUrl: callbackUrl,
                                               payload: payloadGenerator.stubbedPayload)
        
        // When
        sdk.startTinkoffAuth { _ in }
        
        // Then
        XCTAssertEqual(expectedOptions, appLauncher.lastLaunchAppOptions)
    }
    
    func testThatAuthWillBeFinishedWithFailedToLaunchErrorIfPayloadGeneratorThrowsAnError() {
        // Given
        payloadGenerator.stubbedError = ErrorStub.foo
        
        // When
        let result = startTinkoffAuth()!
        
        // Then
        assertErrorEqual(TinkoffAuthError.failedToLaunchApp) {
            try result.get()
        }
    }
    
    func testThatHandleCallbackUrlWillReturnFalseIfThereIsNoAuthorizationFlowStarted() {
        // Given
        let callbackUrl = correctCallbackUrl
        
        // When
        let result = sdk.handleCallbackUrl(callbackUrl)
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testThatHandleCallbackUrlWillReturnFalseIfCallbackUrlDoesNotMatchExpectedOne() {
        // Given
        payloadGenerator.stubbedPayload = .stub
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        let callbackUrl = incorrectCallbackUrl
        
        // When
        var callbackUrlHandlingResult: Bool!
        
        startTinkoffAuth { _ in
            callbackUrlHandlingResult = sdk.handleCallbackUrl(callbackUrl)
        }
        
        // Then
        XCTAssertFalse(callbackUrlHandlingResult)
    }
    
    func testThatHandleCallbackUrlWillReturnTrueIfThereIsAuthorizationFlowStartedAndCallbackUrlMatchExpectedOne() {
        // Given
        payloadGenerator.stubbedPayload = .stub
        callbackParser.stubbedParseResult = .cancelled
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        // When
        var callbackUrlHandlingResult: Bool!
        
        startTinkoffAuth { _ in
            callbackUrlHandlingResult = sdk.handleCallbackUrl(correctCallbackUrl)
        }
        
        // Then
        XCTAssertTrue(callbackUrlHandlingResult)
    }
    
    func testThatCallbackUrlWillBePassedToCallbackParser() {
        // Given
        payloadGenerator.stubbedPayload = .stub
        callbackParser.stubbedParseResult = CallbackURLParseResult?.none
        appLauncher.stubbedLaunchAppCompletionResult = true


        // When
        _ = startTinkoffAuth { _ in
            _ = sdk.handleCallbackUrl(correctCallbackUrl)
        }

        // Then
        XCTAssertEqual(callbackParser.lastParseUrl, correctCallbackUrl)
    }
    
    func testThatAuthFlowWillBeFinishedWithCancelledByUserErrorIfParserProducedSuchResult() {
        // Given
        callbackParser.stubbedParseResult = .cancelled
        payloadGenerator.stubbedPayload = .stub
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        // When
        let result = startTinkoffAuth { _ in
            _ = sdk.handleCallbackUrl(correctCallbackUrl)
        }!
        
        // Then
        assertErrorEqual(TinkoffAuthError.cancelledByUser) {
            try result.get()
        }
    }
    
    func testThatAuthFlowWillBeFinishedWithUnavailableErrorIfParserProducedSuchResult() {
        // Given
        callbackParser.stubbedParseResult = .unavailable
        payloadGenerator.stubbedPayload = .stub
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        // When
        let result = startTinkoffAuth { _ in
            _ = sdk.handleCallbackUrl(correctCallbackUrl)
        }!
        
        // Then
        assertErrorEqual(TinkoffAuthError.unavailable) {
            try result.get()
        }
    }
    
    func testThatAfterReceivingCodeItWillBePassedToApiAmongExpectedParameters() {
        // Given
        let code = "some_code"
        let payload = PKCECodePayload.stub
        
        api.obtainCredentialsResult = .failure(ErrorStub.foo)
        callbackParser.stubbedParseResult = .codeObtained(code)
        payloadGenerator.stubbedPayload = payload
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        // When
        _ = startTinkoffAuth { _ in
            _ = sdk.handleCallbackUrl(correctCallbackUrl)
        }
        
        // Then
        XCTAssertEqual(api.lastObtainCredentialsCode, code)
        XCTAssertEqual(api.lastObtainCredentialsClientId, clientId)
        XCTAssertEqual(api.lastObtainCredentialsCodeVerifier, payload.verifier)
        XCTAssertEqual(api.lastObtainCredentialsRedirectUri, callbackUrl)
    }
    
    func testThatAnyApiErrorWhenObtainingCodeWillBeMappedToFailedToObtainTokenError() {
        // Given
        let code = "some_code"
        let payload = PKCECodePayload.stub
        
        api.obtainCredentialsResult = .failure(ErrorStub.foo)
        callbackParser.stubbedParseResult = .codeObtained(code)
        payloadGenerator.stubbedPayload = payload
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        // When
        let result = startTinkoffAuth { _ in
            _ = sdk.handleCallbackUrl(correctCallbackUrl)
        }!
        
        // Then
        assertErrorEqual(TinkoffAuthError.failedToObtainToken) {
            try result.get()
        }
    }
    
    func testThatAuthCredentialsObtainedWithApiWillBeReturnedAsAuthResult() {
        // Given
        let code = "some_code"
        let payload = PKCECodePayload.stub
        
        api.obtainCredentialsResult = .success(.stub)
        callbackParser.stubbedParseResult = .codeObtained(code)
        payloadGenerator.stubbedPayload = payload
        appLauncher.stubbedLaunchAppCompletionResult = true
        
        // When
        let result = startTinkoffAuth { _ in
            _ = sdk.handleCallbackUrl(correctCallbackUrl)
        }!
        
        // Then
        XCTAssertEqual(try! result.get(), .stub)
    }
    
    func testThatObtainTokenPayloadWillPassCorrectParametersToApi() {
        // Given
        let token = "token"
        api.obtainCredentialsByTokenResult = .failure(ErrorStub.foo)
        
        // When
        _ = obtainTokenPayload(token)
        
        // Then
        XCTAssertEqual(api.lastObtainCredentialsByTokenRefreshToken, token)
        XCTAssertEqual(api.lastObtainCredentialsByTokenClientId, clientId)
    }
    
    func testThatAnyApiErrorWhenObtainingPayloadByTokenWillBeMappedToFailedToRefreshCredentialsError() {
        // Given
        api.obtainCredentialsByTokenResult = .failure(ErrorStub.foo)
        
        // When
        let result = obtainTokenPayload("token")!
        
        // Then
        assertErrorEqual(TinkoffAuthError.failedToRefreshCredentials) {
            try result.get()
        }
    }
    
    func testThatAuthCredentialsObtainedWithApiWillBeReturnedAsObtainResult() {
        // Given
        api.obtainCredentialsByTokenResult = .success(.stub)
        
        // When
        let result = obtainTokenPayload("token")!
        
        // Then
        XCTAssertEqual(try! result.get(), .stub)
    }
    
    func testThatSignOutParamsWillBePassedToApi() {
        // Given
        let token = "token"
        let tokenType = SignOutTokenTypeHint.access
        
        api.signOutResult = .failure(ErrorStub.foo)
        
        // When
        _ = signOut(token: token, tokenTypeHint: tokenType)
        
        // Then
        XCTAssertEqual(api.lastSignOutToken, token)
        XCTAssertEqual(api.lastSignOutTokenTypeHint, tokenType)
        XCTAssertEqual(api.lastSignOutClientId, clientId)
    }
    
    func testThatSignOutApiErrorWillBeReturnedAsSignOutResult() {
        // Given
        let token = "token"
        let tokenType = SignOutTokenTypeHint.access
        
        api.signOutResult = .failure(ErrorStub.foo)
        
        // When
        let result = signOut(token: token, tokenTypeHint: tokenType)!
        
        // Then
        assertErrorEqual(ErrorStub.foo) {
            try result.get()
        }
    }
    
    func testThatSignOutResponseWillBeReturnedAsSignOutResult() {
        // Given
        let token = "token"
        let tokenType = SignOutTokenTypeHint.access
        
        api.signOutResult = .success(SignOutResponse())
        
        // When
        let result = signOut(token: token, tokenTypeHint: tokenType)!
        
        // Then
        assertNoError {
            try result.get()
        }
    }
    
    // MARK: - Private
    
    private var correctCallbackUrl: URL {
        URL(string: self.callbackUrl + "?code=foo")!
    }
    
    private var incorrectCallbackUrl: URL {
        URL(string: "https://foo.bar")!
    }
    
    @discardableResult
    private func startTinkoffAuth(_ hook: (TinkoffID) -> Void = { _ in }) -> Result<TinkoffTokenPayload, TinkoffAuthError>? {
        var result: Result<TinkoffTokenPayload, TinkoffAuthError>?
        
        sdk.startTinkoffAuth {
            result = $0
        }
        
        hook(sdk)
        
        return result
    }
    
    @discardableResult
    private func obtainTokenPayload(_ token: String) -> Result<TinkoffTokenPayload, TinkoffAuthError>? {
        var result: Result<TinkoffTokenPayload, TinkoffAuthError>?
        
        sdk.obtainTokenPayload(using: token) {
            result = $0
        }
        
        return result
    }
    
    @discardableResult
    private func signOut(token: String, tokenTypeHint: SignOutTokenTypeHint) -> Result<Void, Error>? {
        var result: Result<Void, Error>?
        
        sdk.signOut(with: token, tokenTypeHint: tokenTypeHint) {
            result = $0
        }
        
        return result
    }
}
