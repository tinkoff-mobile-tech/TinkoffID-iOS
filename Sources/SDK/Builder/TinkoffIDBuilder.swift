//
//  TinkoffIDBuilder.swift
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

import Foundation
import UIKit

@available(*, deprecated, message: "Please use ITinkoffIDFactory abstraction with its implementation TinkoffIDFactory instead")
public final class TinkoffIDBuilder {
    // Dependenices
    private let factory: TinkoffIDFactory
    
    public convenience init(clientId: String,
                            callbackUrl: String,
                            app: TinkoffApp = .bank,
                            environment: TinkoffEnvironment = .production) {
        self.init(
            clientId: clientId,
            callbackUrl: callbackUrl,
            appConfiguration: app,
            environmentConfiguration: environment
        )
    }
    
    public init(clientId: String,
                callbackUrl: String,
                appConfiguration: TargetAppConfiguration,
                environmentConfiguration: EnvironmentConfiguration) {
        factory = TinkoffIDFactory(
            clientId: clientId,
            callbackUrl: callbackUrl,
            appConfiguration: appConfiguration,
            environmentConfiguration: environmentConfiguration
        )
    }
    
    public func build() -> ITinkoffID {
        factory.build()
    }
}
