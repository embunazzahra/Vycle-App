//
//  Int+Extension.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 10/10/24.
//

import Foundation

extension Int {
    /// Format the integer with thousands separators (periods).
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "." // Use period as the separator
        formatter.locale = Locale(identifier: "id_ID") // Indonesian locale, or adjust as needed
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
