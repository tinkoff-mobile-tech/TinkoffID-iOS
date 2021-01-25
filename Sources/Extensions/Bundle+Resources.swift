//
//  Bundle+Resources.swift
//  TinkoffID
//
//  Created by Dmitry on 24.12.2020.
//

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
