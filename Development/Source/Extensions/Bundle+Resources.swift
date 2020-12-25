//
//  Bundle+Resources.swift
//  TinkoffID
//
//  Created by Dmitry on 24.12.2020.
//

import Foundation

extension Bundle {
    static var resourcesBundle: Bundle? {
        let bundle = Bundle(for: TinkoffIDButton.self)
        
        guard let resourcesBundleUrl = bundle.resourceURL?.appendingPathComponent("TinkoffIdResources.bundle") else {
            return nil
        }
        
        return Bundle(url: resourcesBundleUrl)
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
