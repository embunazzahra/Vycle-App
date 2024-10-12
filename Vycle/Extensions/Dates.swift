//
//  Dates.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 10/10/24.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "id_ID") // Change locale if needed
        return formatter.string(from: self)
    }
}
