//
//  DebugInteractor.swift
//  TinkoffID Debug
//
//  Created by Dmitry Overchuk on 24.06.2021.
//

import Foundation
import UIKit

enum DebugViewResult: Int, CaseIterable {
    case success
    case failure
    case unavailable
    case cancelled
}

protocol DebugViewOutput {
    func handleDebugViewResult(_ result: DebugViewResult)
}

final class DebugInteractor: DebugViewOutput {
    
    private let callbackUrl: String
    
    init?(url: URL) {
        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )
        
        let callbackUrl = components?
            .queryItems?
            .first(where: { item in item.name == .callbackUrlItemName })?
            .value
        
        guard let callbackUrl = callbackUrl else {
            return nil
        }
        
        self.callbackUrl = callbackUrl
    }
    
    func handleDebugViewResult(_ result: DebugViewResult) {
        var components = URLComponents(string: callbackUrl)
        components?.queryItems = [
            URLQueryItem(name: .resultItemName, value: result.resultItemValue)
        ]
        
        if let url = components?.url {
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        }
    }
}

private extension String {
    static let callbackUrlItemName = "callbackUrl"
    static let resultItemName = "result"
}

private extension DebugViewResult {
    var resultItemValue: String {
        switch self {
        case .success:
            return "success"
        case .failure:
            return "failure"
        case .cancelled:
            return "cancelled"
        case .unavailable:
            return "unavailable"
        }
    }
}
