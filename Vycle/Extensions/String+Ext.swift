//
//  String+Ext.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 21/11/24.
//
import Foundation

extension String {
    /// Formats text with thousand separators and removes any non-numeric characters
    func thousandSeparatorFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.groupingSize = 3
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        // Remove all non-numeric characters
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let rawNumberString = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.count),
            withTemplate: ""
        )

        // Convert to NSNumber
        if let doubleValue = Double(rawNumberString) {
            number = NSNumber(value: doubleValue)
        } else {
            return self // Return original if conversion fails
        }

        // Format the number with separators
        return formatter.string(from: number) ?? self
    }
}
