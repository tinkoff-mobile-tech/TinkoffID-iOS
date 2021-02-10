//
//  IURLRouter.swift
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
