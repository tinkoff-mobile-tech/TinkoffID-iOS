//
//  DefaultAuthWebViewSourceProvider.swift
//  TinkoffID
//
//  Copyright (c) 2023 Tinkoff
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

public final class DefaultAuthWebViewSourceProvider: IAuthWebViewSourceProvider {
    
    public static var instance: IAuthWebViewSourceProvider {
        DefaultAuthWebViewSourceProvider()
    }
    
    public func getSourceViewController() -> UIViewController {
        guard let topViewController = UIApplication.topViewController() else {
            fatalError("Ошибка в иерархии вью")
        }
        return topViewController
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
