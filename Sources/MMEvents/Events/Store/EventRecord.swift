//
//  EventRecord.swift
//  moers festival
//
//  Created by Lennart Fischer on 11.03.23.
//  Copyright © 2023 Code for Niederrhein. All rights reserved.
//

import Foundation
import GRDB

public struct EventRecord: Equatable, Codable {
    
    public var id: Int64?
    public var name: String
    public var description: String? = nil
    public var startDate: Date? = nil
    public var endDate: Date? = nil
    
    public var url: String? = nil
    public var category: String? = nil
    
    public var pageID: Int64? = nil
    public var placeID: Int64? = nil
    
    public var publishedAt: Date? = nil
    public var cancelledAt: Date? = nil
    public var scheduledAt: Date? = nil
    public var createdAt: Date? = Date()
    public var updatedAt: Date? = Date()
    public var archivedAt: Date? = nil
    public var deletedAt: Date? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case url
        case category
        case pageID = "page_id"
        case placeID = "place_id"
        case publishedAt = "published_at"
        case cancelledAt = "cancelled_at"
        case scheduledAt = "scheduled_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case archivedAt = "archived_at"
        case deletedAt = "deleted_at"
    }
    
    public func toBase() -> Event {
        
        return Event(
            id: id.toInt() ?? 0,
            name: name,
            description: description,
            url: url,
            startDate: startDate,
            endDate: endDate,
            category: category,
            imagePath: nil,
            web: url != nil ? URL(string: url ?? "") : nil,
            image: nil,
            extras: nil,
            artists: nil,
            pageID: pageID.toInt(),
            placeID: placeID.toInt(),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
}

extension EventRecord: FetchableRecord, MutablePersistableRecord {
    
    public static var databaseTableName: String = "events"
    
    public enum Columns {
        static let name = Column(CodingKeys.name)
        static let description = Column(CodingKeys.description)
        static let startDate = Column(CodingKeys.startDate)
        static let endDate = Column(CodingKeys.startDate)
    }
    
    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
    
    static let place = belongsTo(PlaceRecord.self)
    
    var place: QueryInterfaceRequest<PlaceRecord> {
        request(for: EventRecord.place)
    }
    
}

extension Event {
    
    public func toRecord() -> EventRecord {
        
        return EventRecord(
            id: Int64(truncatingIfNeeded: self.id),
            name: self.name,
            description: self.description,
            startDate: self.startDate,
            endDate: self.endDate,
            url: self.url,
            category: self.category,
            pageID: self.pageID.toInt64(),
            placeID: self.placeID.toInt64(),
            publishedAt: nil,
            cancelledAt: nil,
            scheduledAt: nil,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            archivedAt: nil,
            deletedAt: nil
        )
        
    }
    
}
