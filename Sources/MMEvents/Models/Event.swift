//
//  Event.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import MMPages

public struct Event: BaseEvent {
    
    public typealias ID = Int
    
    public var id: ID
    public var name: String
    public var description: String? = nil
    public var url: String? = nil
    public var startDate: Date? = nil
    public var endDate: Date? = nil
    public var category: String? = nil
    public var imagePath: String? = nil
    public var web: URL? = nil
    public var image: URL? = nil
    public var extras: EventExtras? = nil
    public var pageID: Page.ID? = nil
    public var createdAt: Date? = Date()
    public var updatedAt: Date? = Date()
    
    // Relations
    public var page: Page? = nil
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case url = "url"
        case startDate = "start_date"
        case endDate = "end_date"
        case category = "category"
        case imagePath = "image_path"
        case web = "web"
        case image = "image"
        case extras = "extras"
        case pageID = "page_id"
        case page = "page"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

extension Event {
    
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        return decoder
    }
    
    public static func stub(withID id: Event.ID) -> Event {
        
        return Event(id: id,
                     name: "Test Event",
                     description: nil,
                     url: nil,
                     startDate: nil,
                     endDate: nil,
                     category: nil,
                     imagePath: nil,
                     extras: nil,
                     createdAt: Date(),
                     updatedAt: Date())
        
    }
    
}
