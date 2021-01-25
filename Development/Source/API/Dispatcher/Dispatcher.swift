//
//  Dispatcher.swift
//  TinkoffID
//
//  Created by Dmitry on 19.01.2021.
//

import Foundation

/// Объект, умеющий выполнять определенные блоки кода
protocol Dispatcher {
    /// Выполняет блок кода
    func dispatch(_ block: @escaping () -> Void)
}

extension DispatchQueue: Dispatcher {
    func dispatch(_ block: @escaping () -> Void) {
        async(execute: block)
    }
}
