//
//  EventStore.swift
//  moers festival
//
//  Created by Lennart Fischer on 11.03.23.
//  Copyright © 2023 Code for Niederrhein. All rights reserved.
//

import Foundation
import GRDB
import Combine

final public class EventStore: EventStoring {

    private let writer: DatabaseWriter
    private let reader: DatabaseReader
    
    public init(
        writer: DatabaseWriter,
        reader: DatabaseReader
    ) {
        self.writer = writer
        self.reader = reader
    }

    public func fetch() async throws -> [Event] {

        try await reader.read { db in
            return try EventRecord.fetchAll(db).compactMap { $0.toBase() }
        }

    }
    
    public func insert(_ event: Event) async throws -> Event {

        try await writer.write { db in
            return try event.toRecord().inserted(db).toBase()
        }

    }

    public func delete(_ event: Event) async throws -> Bool {

        try await writer.write { db in
            return try event.toRecord().delete(db)
        }

    }

    @discardableResult
    func updateOrCreate(_ events: [EventRecord]) async throws -> [EventRecord] {
        
        try await writer.write({ db in
            
            var updatedEvents: [EventRecord] = []
            
            for event in events {
                updatedEvents.append(try event.inserted(db, onConflict: .replace))
            }
            
            return updatedEvents
            
        })
        
    }
    
    // MARK: - Observer
    
    public func observeEvents(between startDate: Date, and endDate: Date) -> AnyPublisher<[EventRecord], Error> {
        
        let observation = ValueObservation
            .tracking { db in
                try EventRecord
                    .order(EventRecord.Columns.startDate.desc)
                    .filter(EventRecord.Columns.startDate >= startDate && EventRecord.Columns.startDate <= endDate)
                    .fetchAll(db)
            }
            .removeDuplicates()
        
        return observation.publisher(in: reader).eraseToAnyPublisher()
        
    }
    
}
