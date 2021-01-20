//
//  MockedAppLauncher.swift
//  TinkoffID
//
//  Created by Dmitry on 18.01.2021.
//

import Foundation
@testable import TinkoffID

final class MockedAppLauncher: IAppLauncher {
    var stubbedCanLaunchApp: Bool!
    var stubbedLaunchAppError: Error?
    
    var lastLaunchAppOptions: AppLaunchOptions?
    
    var canLaunchApp: Bool {
        stubbedCanLaunchApp
    }
    
    func launchApp(with options: AppLaunchOptions) throws {
        lastLaunchAppOptions = options
        
        if let error = stubbedLaunchAppError {
            throw error
        }
    }
}
