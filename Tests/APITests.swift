//
//  APITests.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import XCTest
@testable import TinkoffID

class APITests: XCTestCase {
    
    private var api: API!
    private var requestBuilder: MockedRequestBuilder!
    private var requestProcessor: MockedURLRequestProcessor!
    private var dispatcher: DispatcherMock!
    
    private let clientId = "some_client"
    private lazy var encoder = JSONEncoder()

    override func setUpWithError() throws {
        requestBuilder = MockedRequestBuilder()
        requestProcessor = MockedURLRequestProcessor()
        dispatcher = DispatcherMock()
        
        api = API(requestBuilder: requestBuilder,
                  requestProcessor: requestProcessor,
                  responseDispatcher: dispatcher)
    }
    
    // MARK: -

    func testThatObtainCredentialsByCodeWillBuildRequestWithExpectedParameters() {
        // Given
        let code = "foo"
        let codeVerifier = "bar"
        let redirectUri = "baz"
        
        requestBuilder.buildTokenRequestByCodeError = ErrorStub.foo
        
        // When
        api.obtainCredentials(with: code,
                              clientId: clientId,
                              codeVerifier: codeVerifier,
                              redirectUri: redirectUri) { _ in }
        
        // Then
        XCTAssertEqual(requestBuilder.lastBuildTokenRequestByCodeCode, code)
        XCTAssertEqual(requestBuilder.lastBuildTokenRequestByCodeClientId, clientId)
        XCTAssertEqual(requestBuilder.lastBuildTokenRequestByCodeCodeVerifier, codeVerifier)
        XCTAssertEqual(requestBuilder.lastBuildTokenRequestByCodeRedirectUri, redirectUri)
    }
    
    func testThatObtainCredentialsByTokenWillBuildRequestWithExpectedParameters() {
        // Given
        let refreshToken = "foo"
        
        requestBuilder.buildTokenRequestError = ErrorStub.foo
        
        // When
        api.obtainCredentials(with: refreshToken, clientId: clientId) { _ in }
        
        // Then
        XCTAssertEqual(requestBuilder.lastBuildTokenRequestRefreshToken, refreshToken)
        XCTAssertEqual(requestBuilder.lastBuildTokenRequestClientId, clientId)
    }
    
    func testThatSignOutWillBuildRequestWithExpectedParameters() {
        // Given
        let refreshToken = "foo"
        let tokenTypeHint = SignOutTokenTypeHint.refresh
        
        requestBuilder.buildSignOutRequestError = ErrorStub.foo
        
        // When
        api.signOut(with: refreshToken,
                    tokenTypeHint: tokenTypeHint,
                    clientId: clientId) { _ in }
        
        // Then
        XCTAssertEqual(requestBuilder.lastBuildSignOutRequestToken, refreshToken)
        XCTAssertEqual(requestBuilder.lastBuildSignOutRequestClientId, clientId)
        XCTAssertEqual(requestBuilder.lastBuildSignOutRequestTokenTypeHint, tokenTypeHint.rawValue)
    }
    
    // MARK: -
    
    func testThatRequestProcessorProcessMethodWillBeInvokedWithObtainCredentialsByCodeRequestBuildByRequestBuilder() {
        // Given
        let expectedRequest = URLRequest.stub
        
        requestBuilder.buildTokenRequestByCodeResult = expectedRequest
        requestProcessor.stubbedResult = .failure(ErrorStub.foo)
        
        // When
        _ = obtainCredentials()
        
        // Then
        XCTAssertEqual(expectedRequest, requestProcessor.lastProcessRequest)
    }
    
    func testThatRequestProcessorProcessMethodWillBeInvokedWithObtainCredentialsRequestBuildByRequestBuilder() {
        // Given
        let expectedRequest = URLRequest.stub
        
        requestBuilder.buildTokenRequestResult = expectedRequest
        requestProcessor.stubbedResult = .failure(ErrorStub.foo)
        
        // When
        _ = refreshCredentials()
        
        // Then
        XCTAssertEqual(expectedRequest, requestProcessor.lastProcessRequest)
    }
    
    func testThatRequestProcessorProcessMethodWillBeInvokedWithSignOutRequestBuildByRequestBuilder() {
        // Given
        let expectedRequest = URLRequest.stub
        
        requestBuilder.buildSignOutRequestResult = expectedRequest
        requestProcessor.stubbedResult = .failure(ErrorStub.foo)
        
        // When
        _ = signOut()
        
        // Then
        XCTAssertEqual(expectedRequest, requestProcessor.lastProcessRequest)
    }
    
    // MARK: -
    
    func testThatObtainCredentialsByCodeWillBeFinishedWithRequestBuilderErrorIfItsUnableToBuildRequest() {
        // Given
        requestBuilder.buildTokenRequestByCodeError = ErrorStub.foo
        
        // When
        let error = obtainCredentials()!.error as? ErrorStub
        
        // Then
        XCTAssertEqual(error, requestBuilder.buildTokenRequestByCodeError as? ErrorStub)
    }
    
    func testThatObtainCredentialsWillBeFinishedWithRequestBuilderErrorIfItsUnableToBuildRequest() {
        // Given
        requestBuilder.buildTokenRequestError = ErrorStub.foo
        
        // When
        let error = refreshCredentials()!.error as? ErrorStub
        
        // Then
        XCTAssertEqual(error, requestBuilder.buildTokenRequestError as? ErrorStub)
    }
    
    func testThatSignOutWillBeFinishedWithRequestBuilderErrorIfItsUnableToBuildRequest() {
        // Given
        requestBuilder.buildSignOutRequestError = ErrorStub.foo
        
        // When
        let error = signOut()!.error as? ErrorStub
        
        // Then
        XCTAssertEqual(error, requestBuilder.buildSignOutRequestError as? ErrorStub)
    }
    
    // MARK: -
    
    func testThatObtainCredentialsByCodeWillBeFinishedSuccessfullyWhenReceivingCorrectDataFromRequestProcessor() {
        // Given
        let expectedPayload = TinkoffTokenPayload.stub
        
        requestBuilder.buildTokenRequestByCodeResult = .stub
        requestProcessor.stubbedResult = .success(try! encoder.encode(expectedPayload))
        
        // When
        let result = try! obtainCredentials()!.get()
        
        // Then
        XCTAssertEqual(result, expectedPayload)
    }
    
    func testThatObtainCredentialsWillBeFinishedSuccessfullyWhenReceivingCorrectDataFromRequestProcessor() {
        // Given
        let expectedPayload = TinkoffTokenPayload.stub
        
        requestBuilder.buildTokenRequestResult = .stub
        requestProcessor.stubbedResult = .success(try! encoder.encode(expectedPayload))
        
        // When
        let result = try! refreshCredentials()!.get()
        
        // Then
        XCTAssertEqual(result, expectedPayload)
    }
    
    func testThatSignOutWillBeFinishedSuccessfullyWhenReceivingCorrectDataFromRequestProcessor() {
        // Given
        let expectedResult = SignOutResponse.stub
        
        requestBuilder.buildSignOutRequestResult = .stub
        requestProcessor.stubbedResult = .success(try! encoder.encode(expectedResult))
        
        // When
        let result = try! signOut()!.get()
        
        // Then
        XCTAssertNotNil(result)
    }
    
    // MARK: -
    
    func testThatObtainCredentialsByCodeWillBeFailedWhenReceivingIncorrectDataFromRequestProcessor() {
        // Given
        requestBuilder.buildTokenRequestByCodeResult = .stub
        requestProcessor.stubbedResult = .success(try! encoder.encode(SomeStruct.stub))
        
        // When
        let error = obtainCredentials()!.error
        
        // Then
        XCTAssertNotNil(error)
    }
    
    func testThatObtainCredentialsWillBeFailedWhenReceivingIncorrectDataFromRequestProcessor() {
        // Given
        requestBuilder.buildTokenRequestResult = .stub
        requestProcessor.stubbedResult = .success(try! encoder.encode(SomeStruct.stub))
        
        // When
        let error = refreshCredentials()!.error
        
        // Then
        XCTAssertNotNil(error)
    }
    
    // MARK: -
    
    func testThatObtainCredentialsByCodeWillBeFailedWhenReceivingErrorFromRequestProcessor() {
        // Given
        let expectedError = ErrorStub.foo
        
        requestBuilder.buildTokenRequestByCodeResult = .stub
        requestProcessor.stubbedResult = .failure(expectedError)
        
        // When
        let error = obtainCredentials()!.error as? ErrorStub
        
        // Then
        XCTAssertEqual(error, expectedError)
    }
    
    func testThatObtainCredentialsWillBeFailedWhenReceivingErrorFromRequestProcessor() {
        // Given
        let expectedError = ErrorStub.foo
        
        requestBuilder.buildTokenRequestResult = .stub
        requestProcessor.stubbedResult = .failure(expectedError)
        
        // When
        let error = refreshCredentials()!.error as? ErrorStub
        
        // Then
        XCTAssertEqual(error, expectedError)
    }
    
    func testThatSignOutWillBeFailedWhenReceivingErrorFromRequestProcessor() {
        // Given
        let expectedError = ErrorStub.foo
        
        requestBuilder.buildSignOutRequestResult = .stub
        requestProcessor.stubbedResult = .failure(expectedError)
        
        // When
        let error = signOut()!.error as? ErrorStub
        
        // Then
        XCTAssertEqual(error, expectedError)
    }
    
    // MARK: -
    
    func testThatObtainCredentialsByCodeCallbackWillBeDispatchedToSpecifiedDispatcher() {
        // Given
        requestBuilder.buildTokenRequestByCodeResult = .stub
        requestProcessor.stubbedResult = .failure(ErrorStub.foo)
        
        // When
        obtainCredentials()
        
        // Then
        XCTAssertEqual(dispatcher.numberOfDispatches, 1)
    }
    
    func testThatObtainCredentialsCallbackWillBeDispatchedToSpecifiedDispatcher() {
        // Given
        requestBuilder.buildTokenRequestResult = .stub
        requestProcessor.stubbedResult = .failure(ErrorStub.foo)
        
        // When
        refreshCredentials()
        
        // Then
        XCTAssertEqual(dispatcher.numberOfDispatches, 1)
    }
    
    func testThatSignOutCallbackWillBeDispatchedToSpecifiedDispatcher() {
        // Given
        requestBuilder.buildSignOutRequestResult = .stub
        requestProcessor.stubbedResult = .failure(ErrorStub.foo)
        
        // When
        signOut()
        
        // Then
        XCTAssertEqual(dispatcher.numberOfDispatches, 1)
    }
    
    // MARK: - Private
    
    @discardableResult
    private func obtainCredentials() -> Result<TinkoffTokenPayload, Error>? {
        var result: Result<TinkoffTokenPayload, Error>?
        
        api.obtainCredentials(with: "c", clientId: clientId, codeVerifier: "cv", redirectUri: "ru") {
            result = $0
        }
        
        return result
    }
    
    @discardableResult
    private func refreshCredentials() -> Result<TinkoffTokenPayload, Error>? {
        var result: Result<TinkoffTokenPayload, Error>?
        
        api.obtainCredentials(with: "rt", clientId: clientId) {
            result = $0
        }
        
        return result
    }
    
    @discardableResult
    private func signOut() -> Result<SignOutResponse, Error>? {
        var result: Result<SignOutResponse, Error>?
        
        api.signOut(with: "rt", tokenTypeHint: .refresh, clientId: clientId) {
            result = $0
        }
        
        return result
    }
}

private extension Result {
    var error: Failure? {
        switch self {
        case let .failure(error):
            return error
        default:
            return nil
        }
    }
}

private struct SomeStruct: Encodable {
    let a = 1
    let b = 2
    let c = 3
    
    static let stub = SomeStruct()
}
