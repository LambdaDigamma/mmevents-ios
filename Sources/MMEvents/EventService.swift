//
//  EventService.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import ModernNetworking
import Combine

protocol EventServiceProtocol {
    
    associatedtype Event = BaseEvent
    
    func loadEventsFromNetwork() -> AnyPublisher<[Event], Error>
    
//    func loadEventsFromPersistence<E: BaseEvent>() -> AnyPublisher<[E], Error>
    
}

public class EventService<Event: BaseEvent>: EventServiceProtocol {
    
    
    private let loader: HTTPLoader
    
    public init(_ loader: HTTPLoader = URLSessionLoader()) {
        self.loader = loader
    }
    
    func loadEventsFromNetwork() -> AnyPublisher<[Event], Error> {
        
        let request = HTTPRequest(path: Endpoint.index.path())
        
        return Deferred {
            Future { promise in
                self.loader.load(request) { (result) in
                    promise(result)
                }
            }
        }
        .eraseToAnyPublisher()
        .compactMap { $0.body }
        .decode(type: [Event].self, decoder: Event.decoder)
        .map({ $0.chronologically() })
        .eraseToAnyPublisher()
        
    }
    
}

extension EventService {
    
    public enum Endpoint {
        case index
        case show(event: Event)
        
        func path() -> String {
            switch self {
                case .index:
                    return "events"
                case .show(let event):
                    return "events/\(event.id)"
            }
        }
    }
    
}
