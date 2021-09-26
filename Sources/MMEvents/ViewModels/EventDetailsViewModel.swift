//
//  EventDetailsViewModel.swift
//  MMUI
//
//  Created by Lennart Fischer on 13.06.19.
//  Copyright © 2019 LambdaDigamma. All rights reserved.
//

import Foundation
import MapKit
import MMAPI
import Combine

public class EventDetailsViewModel {
    
    public private(set) var config: EventDetailViewConfig?
    public private(set) var model: Event?
    public let observableConfig = CurrentValueSubject<EventDetailViewConfig?, Never>(nil)
    public let event = CurrentValueSubject<Event?, Never>(nil)
    
    public init(model: Event?, config: EventDetailViewConfig? = EventDetailViewConfig()) {
        self.config = config
        self.model = model
        self.observableConfig.send(config)
        self.event.send(model)
    }
    
    public func setNewEvent(_ event: Event?) {
        self.model = event
        self.event.send(event)
    }
    
    public func setNewConfig(_ config: EventDetailViewConfig) {
        self.config = config
        self.observableConfig.send(config)
    }
    
    public var webURL: URL? {
        return URL(string: model?.url ?? "")
    }
    
    public lazy var title: AnyPublisher<String?, Never> = {
        return event.map { $0?.name }.eraseToAnyPublisher()
    }()
    
    public lazy var subtitle: AnyPublisher<String?, Never> = {
        event.map { event in
            if let event = event {
                return EventViewModel(event: event).detailSubtitle
            } else {
                return nil
            }
        }
        .eraseToAnyPublisher()
    }()
    
    public lazy var description: AnyPublisher<String?, Never> = {
        
        return event.map { $0?.description ?? "" }.eraseToAnyPublisher()
        
//        if let locale = Locale.preferredLanguages.first, locale.lowercased().contains("de") {
//            return event.map { $0?.description ?? "" }
//        }
//
//        return event.map { $0?.extras?.descriptionEN ?? $0?.description ?? "" }
        
    }()
    
    public lazy var imageURL: AnyPublisher<URL?, Never> = {
        return event.map { $0?.image }.eraseToAnyPublisher()
    }()
    
    public lazy var url: AnyPublisher<URL?, Never> = {
        return event.map { URL(string: $0?.url ?? "") }.eraseToAnyPublisher()
    }()

    public lazy var location: AnyPublisher<String?, Never> = {
        
        return event.map {
            
            if let location = $0?.place {
                
                return location.name
                
//                let text =
//                """
//                \(location.name)
//                \(location.street) \(location.houseNumber)
//                \(location.place) \(location.postcode)
//                """
//
//                return text
                
            } else if let locationName = $0?.extras?.location {
                return locationName
            } else {
                return String.localized("NotKnownLoc")
            }
            
        }.eraseToAnyPublisher()
        
    }()
    
    public lazy var locationIsSet: AnyPublisher<Bool, Never> = {
        
        return event.map {
            
            if $0?.place != nil {
                return true
            } else if $0?.extras?.location != nil {
                return true
            } else {
                return false
            }
            
        }.eraseToAnyPublisher()
        
    }()
    
    public lazy var isWebsiteButtonEnabled: AnyPublisher<Bool, Never> = {
        
        return event.map {
            
            if URL(string: $0?.url ?? "") != nil {
                return true
            } else {
                return false
            }
            
        }.eraseToAnyPublisher()
        
    }()
    
    public lazy var websiteUIAlpha: AnyPublisher<CGFloat, Never> = {
        return isWebsiteButtonEnabled.map { return $0 ? 1.0 : 0.5 }.eraseToAnyPublisher()
    }()
    
    public lazy var hideTicketText: AnyPublisher<Bool, Never> = {
        return event.map {
            return !($0?.extras?.visitWithExtraTicket ?? false)
        }.eraseToAnyPublisher()
    }()
    
    public lazy var showMovingAct: AnyPublisher<Bool, Never> = {
        return event.map { $0?.extras?.isMovingAct ?? false }.eraseToAnyPublisher()
    }()
    
    public lazy var subtitleAccessibiityLabel: AnyPublisher<String?, Never> = {
        return event.map {
            $0?.name
        }.eraseToAnyPublisher()
    }()
    
//    public lazy var page: SafeSignal<Page?> = {
//        return event.map { $0?.page }
//    }()
    
    public lazy var showVideo: AnyPublisher<Bool, Never> = {
        
        let hasVideoURL = observableConfig.map { $0?.videoURL != nil }
        let shouldShowVideo = observableConfig.map { $0?.showVideo ?? false }
        
        return Publishers
            .CombineLatest(hasVideoURL, shouldShowVideo)
            .map { (hasVideoURL, shouldShowVideo) -> Bool in
                return hasVideoURL && shouldShowVideo
            }
            .eraseToAnyPublisher()
        
    }()
    
    public lazy var showImage: AnyPublisher<Bool, Never> = {
        
        let hasImage = self.imageURL.map { $0 != nil }
        let shouldShowImage = observableConfig.map { $0?.showImage ?? false }
        
        return Publishers
            .CombineLatest(hasImage, shouldShowImage)
            .map { (hasImage, shouldShowImage) -> Bool in
                return hasImage && shouldShowImage
            }
            .eraseToAnyPublisher()
        
    }()
    
    public lazy var showTitleSubtitle: AnyPublisher<Bool, Never> = {
        return Just(true).eraseToAnyPublisher()
    }()
    
    public lazy var showPage: AnyPublisher<Bool, Never> = {
        return event.map { $0?.page != nil }.eraseToAnyPublisher()
    }()
    
    public lazy var showMore: AnyPublisher<Bool, Never> = {
        return Just(false).eraseToAnyPublisher()
    }()
    
    public lazy var showTicketInfo: AnyPublisher<Bool, Never> = {
        return Just(true).eraseToAnyPublisher()
    }()
    
    public lazy var showLocation: AnyPublisher<Bool, Never> = {
        
        let hasLocation = Just(true)
        let shouldShowLocation = observableConfig.map { $0?.showLocation ?? false }
        
        return Publishers
            .CombineLatest(hasLocation, shouldShowLocation)
            .map { (hasLocation, shouldShowLocation) -> Bool in
                return hasLocation && shouldShowLocation
            }
            .eraseToAnyPublisher()
        
    }()
    
    public lazy var streamURL: AnyPublisher<URL?, Never> = {
        return observableConfig.map { $0?.videoURL }.eraseToAnyPublisher()
    }()
    
    public lazy var showNoInformtation: AnyPublisher<Bool, Never> = {
        return Just(false).eraseToAnyPublisher()
    }()
    
}
