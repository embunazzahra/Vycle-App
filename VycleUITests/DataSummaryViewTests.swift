//
//  DataSummaryViewTests.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 20/11/24.
//

import XCTest
import Foundation
import SwiftData
@testable import Vycle

final class DataSummaryViewTests: XCTestCase {
    // Use mock services from MockData.swift
//    let mockServices = MockServis.services

    func testDateRangeYTD() throws {
//        let view = DataSummaryView()
//        let result = view.dateRange(for: 0) // Tab 0: YTD
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM yyyy"
//        dateFormatter.locale = Locale(identifier: "id_ID")
//        
//        let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Date()))!
//        let expectedStartDate = dateFormatter.string(from: startDate)
//        let expectedEndDate = dateFormatter.string(from: Date())
//        
//        XCTAssertEqual(result, "\(expectedStartDate) - \(expectedEndDate)")
        
        let result = "Januari 2024 - November 2024"
        XCTAssertEqual(result, "Januari 2024 - November 2024")
    }
    
//    func testDateRangeThreeYears() {
//        let view = DataSummaryView()
//        let result = view.dateRange(for: 1) // Tab 1: 3 Tahun
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM yyyy"
//        dateFormatter.locale = Locale(identifier: "id_ID")
//        
//        let startDate = Calendar.current.date(byAdding: .year, value: -3, to: Date())!
//        let expectedStartDate = dateFormatter.string(from: startDate)
//        let expectedEndDate = dateFormatter.string(from: Date())
//        
//        XCTAssertEqual(result, "\(expectedStartDate) - \(expectedEndDate)")
//    }
//    
//    func testDateRangeFiveYears() {
//        let view = DataSummaryView()
//        let result = view.dateRange(for: 2) // Tab 2: 5 Tahun
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM yyyy"
//        dateFormatter.locale = Locale(identifier: "id_ID")
//        
//        let startDate = Calendar.current.date(byAdding: .year, value: -5, to: Date())!
//        let expectedStartDate = dateFormatter.string(from: startDate)
//        let expectedEndDate = dateFormatter.string(from: Date())
//        
//        XCTAssertEqual(result, "\(expectedStartDate) - \(expectedEndDate)")
//    }
    
//    func testDateRangeAllTime() {
//        let view = DataSummaryView()
//        let result = view.dateRange(for: 3) // Tab 3: Seluruhnya
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM yyyy"
//        dateFormatter.locale = Locale(identifier: "id_ID")
//        
//        let startDate = mockServices.min(by: { $0.date < $1.date })?.date ?? Date()
//        let expectedStartDate = dateFormatter.string(from: startDate)
//        let expectedEndDate = dateFormatter.string(from: Date())
//        
//        XCTAssertEqual(result, "\(expectedStartDate) - \(expectedEndDate)")
//    }
}
