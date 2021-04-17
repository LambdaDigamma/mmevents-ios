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

private let keyLikes = "likedEventIDs"

extension EventServiceProtocol {
    
    // MARK: - Like Handling
    
    public static func getLikedIDs() -> [Event.ID] {
        
        let likeIDs = UserDefaults.standard.array(forKey: keyLikes) as? [Event.ID]
        
        return likeIDs ?? []
        
    }
    
    public static func toggleLike(for id: Event.ID) -> Bool {
        
        var likedIDs = getLikedIDs()
        var isLiked = false
        
        if let likedIndex = likedIDs.firstIndex(of: id) {
            
            likedIDs.remove(at: likedIndex)
            isLiked = false
            
        } else {
            
            likedIDs.append(id)
            isLiked = true
            
        }
        
        UserDefaults.standard.set(likedIDs.sorted(), forKey: keyLikes)
        
        return isLiked
        
    }
    
    public static func setLikeStatus(likeStatus: Bool, for id: Event.ID) {
        
        var likedIDs = getLikedIDs()
        
        if likeStatus {
            likedIDs.append(id)
        } else {
            likedIDs.removeAll(where: { $0 == id })
        }
        
        let set = Set(likedIDs)
        
        let array = Array(set)
        
        UserDefaults.standard.set(array.sorted(), forKey: keyLikes)
        
    }
    
    public static func isLiked(id: Event.ID) -> Bool {
        
        return getLikedIDs().first(where: { $0 == id }) != nil
        
    }
    
}
