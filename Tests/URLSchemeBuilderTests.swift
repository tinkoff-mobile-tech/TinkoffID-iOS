//
//  URLSchemeBuilderTests.swift
//  TinkoffID
//
//  Created by Dmitry on 14.01.2021.
//

import XCTest
@testable import TinkoffID

class URLSchemeBuilderTests: XCTestCase {
    
    private var builder: URLSchemeBuilder!
    private let baseUrlString = "someapp://"

    override func setUpWithError() throws {
        builder = URLSchemeBuilder(baseUrlString: baseUrlString)
    }
    
    func testThatBuilderProducesUrlWithCorrectBaseUrl() {
        // Given
        let expectedBaseUrl = baseUrlString
        
        // When
        let components = buildSampleUrlComponents()
        
        // Then
        XCTAssertEqual(components.scheme! + "://", expectedBaseUrl)
    }
    
    func testThatBuilderProducesUrlWithCorrectQueryParameters() {
        // Given
        let launchOptions = AppLaunchOptions.stub
        
        let expectedQueryItems = [
            URLSchemeBuilder.Param.clientId: launchOptions.clientId,
            URLSchemeBuilder.Param.codeChallenge: launchOptions.payload.challenge,
            URLSchemeBuilder.Param.codeChallengeMethod: launchOptions.payload.challengeMethod,
            URLSchemeBuilder.Param.callbackUrl: launchOptions.callbackUrl
        ]
        
        // When
        let components = buildSampleUrlComponents()
        
        // Then
        let containsUnexpectedResults = components.queryItems?.count != expectedQueryItems.count
        let containsNonMatchedItems = expectedQueryItems.contains(where: { item in
            components.queryItems?.contains(where: {
                $0.name == item.key.rawValue && $0.value == item.value
            }) == false
        })
            
        XCTAssertFalse(containsUnexpectedResults || containsNonMatchedItems)
    }
    
    // MARK: - Private
    
    private func buildSampleUrlScheme() -> URL {
        try! builder.buildUrlScheme(with: .stub)
    }
    
    private func buildSampleUrlComponents() -> URLComponents {
        URLComponents(url: buildSampleUrlScheme(),
                      resolvingAgainstBaseURL: true)!
    }
}
