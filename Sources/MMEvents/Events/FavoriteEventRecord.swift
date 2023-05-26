//
//  FavoriteEventRecord.swift
//  
//
//  Created by Lennart Fischer on 29.04.23.
//

import Foundation
import GRDB

public struct FavoriteEventRecord: Equatable, Codable {
    
    public var id: Int64?
    public var eventID: Int64
    
    public var createdAt: Date?
    public var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

extension FavoriteEventRecord: FetchableRecord, MutablePersistableRecord {
    
    public static var databaseTableName: String = FavoriteEventsTableDefinition.tableName
    
    public enum Columns {
        static let eventID = Column(CodingKeys.eventID)
    }
    
    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
    
    static let eventForeignKey = ForeignKey(["event_id"])
    
    static let event = belongsTo(EventRecord.self, using: eventForeignKey)
    
    var event: QueryInterfaceRequest<EventRecord> {
        request(for: FavoriteEventRecord.event)
    }
    
}
