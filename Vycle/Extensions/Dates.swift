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
    
    func startOfMonth() -> Date {
        // Get the current date components
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 2 // Set the day to the first of the month

        guard let startOfMonth = Calendar.current.date(from: components) else {
            fatalError("Could not create date from components")
        }
        
        return startOfMonth // Return the Date object
    }
}
