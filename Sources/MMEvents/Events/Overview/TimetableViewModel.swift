//
//  TimetableViewModel.swift
//  
//
//  Created by Lennart Fischer on 11.04.23.
//

import Foundation
import Factory
import Combine
import Core

public class TimetableViewModel: ObservableObject {
    
    @Published var selectedDate: Date = .init()
    
    private let repository: EventRepository
    
    @Published public var dates: [Date] = []
    public var cancellables = Set<AnyCancellable>()
    
    public init() {
        
        self.repository = Container.shared.eventRepository()
        
        self.setupObserver()
        
    }
    
    public func setupObserver() {
        
        repository.events()
            .sink { (completion: Subscribers.Completion<Error>) in
                
                
                
            } receiveValue: { (events: [Event]) in
                
                self.dates = DateUtils.sortedUniqueDates(events.compactMap { $0.startDate })
                
                if self.dates.contains(where: { $0.isToday }) {
                    self.selectedDate = Date()
                } else {
                    self.selectedDate = self.dates.first ?? Date()
                }
                
            }
            .store(in: &cancellables)

        
    }
    
    public func load() {
        
        Task {
            try await repository.reloadEvents()
        }
        
    }
    
}
