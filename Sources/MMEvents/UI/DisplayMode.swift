//
//  DisplayMode.swift
//  MMUI
//
//  Created by Lennart Fischer on 12.06.19.
//  Copyright © 2019 LambdaDigamma. All rights reserved.
//

import Foundation

public enum DisplayMode {
    
    case overview(favouriteEvents: [Event], activeEvents: [Event], upcomingEvents: [Event])
    case list(keyedEvents: [(header: String, events: [Event])])
    case search(searchTerm: String, searchedEvents: [(header: String, events: [Event])])
    case favourites(keyedEvents: [(header: String, events: [Event])])
    case filter(filteredEvents: [Event])
    
}
