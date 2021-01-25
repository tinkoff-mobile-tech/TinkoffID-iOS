//
//  URLSchemeAppLauncherTests.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import XCTest
@testable import TinkoffID

class URLSchemeAppLauncherTests: XCTestCase {
    
    private lazy var appUrlScheme = "someapp://"
    private var launcher: URLSchemeAppLauncher!
    private var schemeBuilder: MockedURLSchemeBuilder!
    private var router: MockedURLRouter!

    override func setUpWithError() throws {
        schemeBuilder = MockedURLSchemeBuilder()
        router = MockedURLRouter()
        
        launcher = URLSchemeAppLauncher(appUrlScheme: appUrlScheme,
                                        builder: schemeBuilder,
                                        router: router)
    }
    
    func testThatCanLaunchAppGetterWillInvokeRouterCanOpenURLMethodWithExpectedUrlScheme() {
        // Given
        let expectedUrlString = appUrlScheme
        router.nextCanOpenUrlResult = true
        
        // When
        _ = launcher.canLaunchApp
        
        // Then
        XCTAssertEqual(router.lastCheckedUrl, URL(string: expectedUrlString)!)
    }
    
    func testThatAppLaunchOptionsWillBePassedToUrlSchemeBuilderWhenLaunchingApp() {
        // Given
        let expectedOptions = AppLaunchOptions.stub
        
        schemeBuilder.nextBuildUrlSchemeResult = URL(string: appUrlScheme)
        router.nextOpenResult = true
        
        // When
        try! launcher.launchApp(with: expectedOptions)
        
        // Then
        XCTAssertEqual(expectedOptions, schemeBuilder.lastOptions)
    }
    
    func testThatURLWillBePassedToRouterAfterConstructing() {
        // Given
        let expectedUrl = URL(string: appUrlScheme)
        
        schemeBuilder.nextBuildUrlSchemeResult = expectedUrl
        router.nextOpenResult = true
        
        // When
        assertNoError(message: "App has to be launched") {
            try launcher.launchApp(with: .stub)
        }
        
        // Then
        XCTAssertEqual(router.lastOpenedURL, expectedUrl)
    }
    
    func testThatErrorWillBeThrownIfItsUnableToLaunchApp() {
        // Given
        schemeBuilder.nextBuildUrlSchemeResult = URL(string: appUrlScheme)
        router.nextOpenResult = false
        
        // When
        let when = { try self.launcher.launchApp(with: .stub) }
        
        // Then
        assertErrorEqual(URLSchemeAppLauncher.Error.launchFailure, when)
    }
}
