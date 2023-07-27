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
        try! launcher.launchApp(with: expectedOptions, completion: { _ in })
        
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
            try launcher.launchApp(with: .stub) { _ in }
        }
        
        // Then
        XCTAssertEqual(router.lastOpenedURL, expectedUrl)
    }
    
    func testThatErrorWillBeThrownIfItsUnableToLaunchApp() {
        // Given
        schemeBuilder.nextBuildUrlSchemeResult = URL(string: appUrlScheme)
        router.nextOpenResult = false
        
        // When
        let when = { try self.launcher.launchApp(with: .stub) { _ in } }
        
        // Then
        assertErrorEqual(URLSchemeAppLauncher.Error.launchFailure, when)
    }
}
