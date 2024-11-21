//
//  ThousandSeparatorView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 21/11/24.
//

import Foundation
import SwiftUI


class NumberStore<T: Numeric, F: ParseableFormatStyle>: ObservableObject where F.FormatOutput == String, F.FormatInput == T {
    @Published var text: String
    let type: ValidationType
    let maxLength: Int
    let allowNegative: Bool
    private var backupText: String
    @Published var error: Bool = false
    private let locale: Locale
    let formatter: F
    
    init(
        text: String = "",
        type: ValidationType,
        maxLength: Int = 18,
        allowNegative: Bool = false,
        formatter: F,
        locale: Locale = .current
    ) {
        self.text = text
        self.type = type
        self.allowNegative = allowNegative
        self.formatter = formatter
        self.locale = locale
        self.backupText = text
        self.maxLength = maxLength == .max ? .max - 1 : maxLength
    }
    
    var result: T? {
        try? formatter.parseStrategy.parse(text)
    }
    
    func restore() {
        text = backupText
    }
    
    func backup() {
        backupText = text
    }
    
    lazy var decimalSeparator: String = {
        locale.decimalSeparator ?? "."
    }()
    
    let minusCharacter = "-"
    lazy var groupingSeparator: String = {
        locale.groupingSeparator ?? ","
    }()
    
    private lazy var characters: String = {
        let number = "0123456789"
        switch type {
        case .int:
            return number + (allowNegative ? minusCharacter : "")
        case .double:
            return number + (allowNegative ? minusCharacter : "") + decimalSeparator
        }
    }()
    
    func getValue() -> T? {
        if text.isEmpty || text == minusCharacter || (type == .double && text == decimalSeparator) {
            backup()
            return nil
        }
        
        let pureText = text.replacingOccurrences(of: groupingSeparator, with: "")
        guard pureText.allSatisfy({ characters.contains($0) }) else {
            restore()
            return nil
        }
        
        if let value = try? formatter.parseStrategy.parse(text) {
            text = formatter.format(value)
            backup()
            return value
        } else {
            restore()
            return nil
        }
    }
    
    enum ValidationType {
        case int
        case double
    }
}
