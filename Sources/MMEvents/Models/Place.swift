//
//  Place.swift
//  
//
//  Created by Lennart Fischer on 25.04.21.
//

import Foundation
import ModernNetworking

public struct Place: Model {
    
    public typealias ID = Int
    
    public var id: ID
    public var name: String
    public var extras: PlaceExtras? = nil
    public var createdAt: Date? = Date()
    public var updatedAt: Date? = Date()
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case extras = "extras"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public struct PlaceExtras: Codable {
        
    }
    
}

extension Place {
    
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        return decoder
    }
    
    public static func stub(withID id: Place.ID) -> Place {
        
        return Place(
            id: id,
            name: "Testort",
            createdAt: Date(),
            updatedAt: Date()
        )
        
    }
    
}
