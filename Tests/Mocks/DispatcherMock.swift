//
//  DispatcherMock.swift
//  TinkoffID
//
//  Created by Dmitry on 19.01.2021.
//

import Foundation
@testable import TinkoffID

final class DispatcherMock: Dispatcher {
    
    var numberOfDispatches = Int.zero
    
    func dispatch(_ block: @escaping () -> Void) {
        numberOfDispatches += 1
        
        block()
    }
}
