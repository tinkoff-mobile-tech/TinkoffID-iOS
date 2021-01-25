//
//  IURLRouter.swift
//  TinkoffID
//
//  Created by Dmitry on 20.01.2021.
//

import Foundation
import UIKit

/// Роутер URL
protocol IURLRouter {
    /// Возвращает `true` если заданный URL может быть открыт
    func canOpenURL(_ url: URL) -> Bool
    
    /// Открывает заданный URL и возвращает `true` если открытие удалось
    func open(_ url: URL) -> Bool
}

extension UIApplication: IURLRouter {
    func open(_ url: URL) -> Bool {
        guard canOpenURL(url) else { return false }
        
        open(url, options: [:], completionHandler: nil)
        
        return true
    }
}
