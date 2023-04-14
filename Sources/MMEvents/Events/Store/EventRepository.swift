//
//  EventRepository.swift
//  
//
//  Created by Lennart Fischer on 11.03.23.
//

import Foundation
import Combine
import Factory
import GRDB

extension Container {
    
    public var eventRepository: Factory<EventRepository> {
        Factory(self) {

            guard let dbQueue = try? DatabaseQueue(path: ":memory:") else { fatalError() }
            
            return EventRepository(
                store: EventStore(writer: dbQueue, reader: dbQueue),
                service: StaticEventService(events: .success([]))
            )

        }.singleton
    }
    
}

public class EventRepository {
    
    private let store: EventStore
    private let service: EventService
    
    public init(store: EventStore, service: EventService) {
        self.store = store
        self.service = service
    }
    
    // MARK: - Data Source
    
    public func events(between startDate: Date, and endDate: Date) -> AnyPublisher<[Event], Error> {
        
        return store.observeEvents(between: startDate, and: endDate)
            .map { $0.map { $0.toBase() } }
            .eraseToAnyPublisher()
        
    }
    
    // MARK: - Networking
    
    /// Refreshes the events while skipping all client cache layers
    /// and writes all new data to disk so that the database observation
    /// as the single source of truth can reload the user interface.
    public func refreshEvents() async throws {
        
        let resource = try await service.index(cacheMode: .revalidate)
        
        try await updateStore(events: resource.data)
        
    }
    
    /// Reloads the events while going through all client cache layers
    /// and writes all new data to disk so that the database observation
    /// as the single source of truth can reload the user interface.
    ///
    /// - Throws: An error when an error occurs while loading the
    /// data from the network.
    public func reloadEvents() async throws {
        
        let resource = try await service.index(cacheMode: .cached)
        
        try await updateStore(events: resource.data)
        
    }
    
    // MARK: - Database Handling
    
    /// Write the events to the database.
    ///
    /// - Throws: any errors from the underlying database implementation.
    private func updateStore(events: [Event]) async throws {
        
        try await store.updateOrCreate(events.map { $0.toRecord() })
        
    }
    
}
