//
//  EventService.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import ModernNetworking
import Combine
import Cache

public protocol EventServiceProtocol {
    
    func loadEventsFromNetwork() -> AnyPublisher<[Event], Error>
    
    func loadEventsFromPersistence() -> AnyPublisher<[Event], Error>
    
    func invalidateCache()
    
}

public class EventService: EventServiceProtocol {
    
    private let loader: HTTPLoader
    private let cache: Storage<String, [Event]>
    
    public init(_ loader: HTTPLoader = URLSessionLoader(), _ cache: Storage<String, [Event]>) {
        self.loader = loader
        self.cache = cache
    }
    
    public func loadEventsFromNetwork() -> AnyPublisher<[Event], Error> {
        
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
        .decode(type: ResourceCollection<Event>.self, decoder: Event.decoder)
        .map({
            $0.data.chronologically()
        })
        .map({
            self.cache.async.setObject($0, forKey: "events") { (result) in }
            return $0
        })
        .eraseToAnyPublisher()
        
    }
    
    public func loadEventsFromPersistence() -> AnyPublisher<[Event], Error> {
        return Deferred {
            Future { promise in
                self.cache.async.object(forKey: CachingKeys.events.rawValue) { (result: Result<[Event]>) in
                    switch result {
                        case .value(let v):
                            promise(.success(v))
                            break
                        case .error(let e):
                            promise(.failure(e))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func invalidateCache() {
        try? cache.removeAll()
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
    
    public enum CachingKeys: String {
        case events = "events"
    }
    
}
