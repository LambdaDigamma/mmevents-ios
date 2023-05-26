//
//  FavoriteEventsStore.swift
//  
//
//  Created by Lennart Fischer on 29.04.23.
//

import Foundation
import GRDB
import Combine
import Factory

extension Container {
    
    public var favoriteEventsStore: Factory<FavoriteEventsStore?> {
        Factory(self) {
            
            return nil
            
        }.singleton
    }
    
}

final public class FavoriteEventsStore {
    
    private let writer: DatabaseWriter
    private let reader: DatabaseReader
    
    public init(
        writer: DatabaseWriter,
        reader: DatabaseReader
    ) {
        self.writer = writer
        self.reader = reader
    }
    
    public func isFavorite(eventID: Event.ID) async throws -> Bool {
        
        return try await reader.read { db in
            return try FavoriteEventRecord
                .filter(FavoriteEventRecord.Columns.eventID == eventID)
                .isEmpty(db) == false
        }
        
    }
    
    @discardableResult
    public func createFavoriteEvent(eventID: Event.ID) async throws -> FavoriteEventRecord {
        
        return try await writer.write { db in
            return try FavoriteEventRecord(id: nil, eventID: eventID.toInt64(), createdAt: Date(), updatedAt: Date())
                .inserted(db)
        }
        
    }
    
    public func deleteFavoriteEvent(eventID: Event.ID) async throws {
        
        _ = try await writer.write { db in
            try FavoriteEventRecord
                .filter(FavoriteEventRecord.Columns.eventID == eventID)
                .deleteAll(db)
        }
        
    }
    
    @discardableResult
    public func toggleFavoriteEvent(eventID: Event.ID) async throws -> Bool {
        
        if try await isFavorite(eventID: eventID) {
            try await deleteFavoriteEvent(eventID: eventID)
            return false
        } else {
            try await createFavoriteEvent(eventID: eventID)
            return true
        }
        
    }
    
    // MARK: - Observer
    
    public func isLiked(eventID: Event.ID) -> AnyPublisher<Bool, Error> {
        
        let observation = ValueObservation
            .tracking { db in
                try FavoriteEventRecord
                    .filter(FavoriteEventRecord.Columns.eventID == eventID)
                    .fetchOne(db)
            }
            .removeDuplicates()
        
        return observation
            .publisher(in: reader)
            .map({ (record: FavoriteEventRecord?) in
                return record != nil
            })
            .eraseToAnyPublisher()
        
    }
    
}
