//
//  DayEventsViewModel.swift
//  
//
//  Created by Lennart Fischer on 11.04.23.
//

import Foundation
import Factory
import Combine

public class DayEventsViewModel: ObservableObject {
    
    private let date: Date
    internal let startDate: Date
    internal let endDate: Date
    
    @Published var events: [EventListItemViewModel] = []
    
    private let repository: EventRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(date: Date) {
        self.date = date
        self.repository = Container.shared.eventRepository()
        
        let range = Self.calculateDateRange(for: date, offset: 60 * 60 * 4)
        self.startDate = range.startDate
        self.endDate = range.endDate
        
        self.setupObserver()
        
    }
    
    public func setupObserver() {
        
        repository.events(between: startDate, and: endDate)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { (error: Subscribers.Completion<Error>) in
                
            } receiveValue: { (events: [Event]) in
                self.events = events.map {
                    EventListItemViewModel(
                        eventID: $0.id,
                        title: $0.name,
                        startDate: $0.startDate,
                        endDate: $0.endDate,
                        location: $0.extras?.location
                    )
                }
            }
            .store(in: &cancellables)

        
    }
    
    // MARK: - Actions
    
    public func reload() {
        
        Task {
            try await repository.reloadEvents()
        }
        
    }
    
    public func refresh() {
        
        Task {
            try await repository.refreshEvents()
        }
        
    }
    
    // MARK: - Date Range
    
    public static func calculateDateRange(
        for date: Date,
        offset: TimeInterval,
        calendar: Calendar = Calendar.autoupdatingCurrent
    ) -> (startDate: Date, endDate: Date) {
        
        // Get the start of the day for the given date
        let startOfDay = calendar.startOfDay(for: date)
        
        // Add the offset to the start of the day to get the start date of the range
        let startDate = calendar.date(byAdding: .second, value: Int(offset), to: startOfDay)!
        
        // Add the offset plus 24 hours to the start of the day to get the end date of the range
        let endDate = calendar.date(byAdding: .second, value: Int(offset) + 86400, to: startOfDay)!
        
        return (startDate, endDate)
    }
    
}
