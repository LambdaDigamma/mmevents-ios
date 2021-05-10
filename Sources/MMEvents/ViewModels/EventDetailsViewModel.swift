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
import Bond
import ReactiveKit

public class EventDetailsViewModel {
    
    public private(set) var config: EventDetailViewConfig?
    public private(set) var model: Event?
    public let observableConfig = SafeReplayOneSubject<EventDetailViewConfig?>()
    public let event = SafeReplayOneSubject<Event?>()
    
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
    
    public lazy var title: SafeSignal<String?> = {
        return event.map { $0?.name }
    }()
    
    public lazy var subtitle: SafeSignal<String?> = {
        event.map { event in
            if let event = event {
                return EventViewModel(event: event).detailSubtitle
            } else {
                return nil
            }
        }
    }()
    
    public lazy var description: SafeSignal<String?> = {
        
        return event.map { $0?.description ?? "" }
        
//        if let locale = Locale.preferredLanguages.first, locale.lowercased().contains("de") {
//            return event.map { $0?.description ?? "" }
//        }
//
//        return event.map { $0?.extras?.descriptionEN ?? $0?.description ?? "" }
        
    }()
    
    public lazy var imageURL: SafeSignal<URL?> = {
        return event.map { $0?.image }
    }()
    
    public lazy var url: SafeSignal<URL?> = {
        return event.map { URL(string: $0?.url ?? "") }
    }()
    
    public lazy var location: SafeSignal<String?> = {
        
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
            
        }
        
    }()
    
    public lazy var locationIsSet: SafeSignal<Bool> = {
        
        return event.map {
            
            if $0?.place != nil {
                return true
            } else if $0?.extras?.location != nil {
                return true
            } else {
                return false
            }
            
        }
        
    }()
    
    public lazy var isWebsiteButtonEnabled: SafeSignal<Bool> = {
        
        return event.map {
            
            if URL(string: $0?.url ?? "") != nil {
                return true
            } else {
                return false
            }
            
        }
        
    }()
    
    public lazy var websiteUIAlpha: SafeSignal<CGFloat> = {
        return isWebsiteButtonEnabled.map { return $0 ? 1.0 : 0.5 }
    }()
    
    public lazy var hideTicketText: SafeSignal<Bool> = {
        return event.map {
            return !($0?.extras?.visitWithExtraTicket ?? false)
        }
    }()
    
    public lazy var showMovingAct: SafeSignal<Bool> = {
        return event.map { $0?.extras?.isMovingAct ?? false }
    }()
    
    public lazy var subtitleAccessibiityLabel: SafeSignal<String?> = {
        return event.map {
            $0?.name
        }
    }()
    
//    public lazy var page: SafeSignal<Page?> = {
//        return event.map { $0?.page }
//    }()
    
    public lazy var showVideo: SafeSignal<Bool> = {
        
        let hasVideoURL = observableConfig.map { $0?.videoURL != nil }
        let shouldShowVideo = observableConfig.map { $0?.showVideo ?? false }
        
        return combineLatest(hasVideoURL, shouldShowVideo) { (hasVideoURL, shouldShowVideo) -> Bool in
            return hasVideoURL && shouldShowVideo
        }
        
    }()
    
    public lazy var showImage: SafeSignal<Bool> = {
        
        let hasImage = self.imageURL.map { $0 != nil }
        let shouldShowImage = observableConfig.map { $0?.showImage ?? false }
        
        return combineLatest(hasImage, shouldShowImage) { (hasImage, shouldShowImage) -> Bool in
            return hasImage && shouldShowImage
        }
        
    }()
    
    public lazy var showTitleSubtitle: SafeSignal<Bool> = {
        return Signal {
            return true
        }
    }()
    
    public lazy var showPage: SafeSignal<Bool> = {
        return event.map { $0?.page != nil }
    }()
    
    public lazy var showMore: SafeSignal<Bool> = {
        return Signal {
            return false
        }
    }()
    
    public lazy var showTicketInfo: SafeSignal<Bool> = {
        return Signal {
            return true
        }
    }()
    
    public lazy var showLocation: SafeSignal<Bool> = {
        
        let hasLocation = SafeSignal(just: true)
        let shouldShowLocation = observableConfig.map { $0?.showLocation ?? false }
        
        return combineLatest(hasLocation, shouldShowLocation) { (hasLocation, shouldShowLocation) -> Bool in
            return hasLocation && shouldShowLocation
        }
        
    }()
    
    public lazy var streamURL: SafeSignal<URL?> = {
        return observableConfig.map { $0?.videoURL }
    }()
    
    public lazy var showNoInformtation: SafeSignal<Bool> = {
        return Signal {
            return self.event == nil
        }
    }()
    
}
