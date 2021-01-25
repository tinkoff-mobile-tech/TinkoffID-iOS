//
//  IPKCEPayloadGenerator.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 24.03.2020.
//

import Foundation

/// Описывает объект, создающий `PKCECodePayload`'ы
protocol IPKCEPayloadGenerator {
    
    /// Создает и возвращает новый `PKCECodePayload`
    func generatePayload() throws -> PKCECodePayload
}
