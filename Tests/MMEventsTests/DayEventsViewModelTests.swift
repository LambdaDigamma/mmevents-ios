//
//  DayEventsViewModelTests.swift
//  
//
//  Created by Lennart Fischer on 12.04.23.
//

import Foundation
import XCTest
@testable import MMEvents

final class DayEventsViewModelTests: XCTestCase {
    
    func testRange() {
        
        let date = Date(timeIntervalSince1970: 1681251959)
        
        let (start, end) = DayEventsViewModel.calculateDateRange(
            for: date,
            offset: 4 * 60 * 60,
            calendar: .init(identifier: .gregorian)
        )
        
        XCTAssertEqual(start.timeIntervalSince1970, 1681264800)
        XCTAssertEqual(end.timeIntervalSince1970, 1681351200)
        
    }
    
}
