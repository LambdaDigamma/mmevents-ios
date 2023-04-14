//
//  TimetableViewModel.swift
//  
//
//  Created by Lennart Fischer on 11.04.23.
//

import Foundation

public class TimetableViewModel: ObservableObject {
    
    @Published var selectedDate: Date = .init()
    
    public var dates: [Date] = []
    
    public init() {
        
        self.dates = [
            Date(),
            Date(timeIntervalSinceNow: 60 * 60 * 24),
            Date(timeIntervalSinceNow: 60 * 60 * 24 * 2),
            Date(timeIntervalSinceNow: 60 * 60 * 24 * 3),
        ]
        
    }
    
}
