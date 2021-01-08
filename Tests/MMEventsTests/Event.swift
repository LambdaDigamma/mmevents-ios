//
//  Event.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import MMEvents

struct Event: BaseEvent {
    
    var id: EventID
    var name: String
    var description: String? = nil
    var url: String? = nil
    var startDate: Date? = nil
    var endDate: Date? = nil
    var category: String? = nil
    var imagePath: String? = nil
    var web: URL? = nil
    var image: URL? = nil
    var extras: EventExtras? = nil
    
    var createdAt: Date? = Date()
    var updatedAt: Date? = Date()
    
    static func stub(withID id: Int) -> Event {
        
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
