//
//  Bundle+Resources.swift
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

extension Bundle {
    static var resourcesBundle: Bundle? {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: TinkoffIDButton.self)
            .resourceURL
            .flatMap(Bundle.init(url:))
        #endif
    }
    
    func imageNamed(_ name: String) -> UIImage? {
        UIImage(named: name,
                in: self,
                compatibleWith: nil)
    }
    
    func localizedString(_ key: String) -> String {
        localizedString(forKey: key, value: nil, table: "TinkoffID")
    }
}
