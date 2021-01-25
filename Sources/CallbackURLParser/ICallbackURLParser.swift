//
//  ICallbackURLParser.swift
//  TinkoffID
//
//  Created by Dmitry Overchuk on 30.03.2020.
//

import Foundation

/// Результат обработки URL
enum CallbackURLParseResult: Equatable {
    /// Удалось извлечь код
    case codeObtained(String)
    /// Удалось извлечь флаг об отмене процесса пользователем
    case cancelled
    /// Удалось извлечь флаг о недоступности SSO
    case unavailable
}

/// Парсер URL обратного вызова
protocol ICallbackURLParser {
    
    /// Обрабатывает переданный URL и возвращает соотвествующий `CallbackURLParseResult`
    func parse(_ url: URL) -> CallbackURLParseResult?
}
