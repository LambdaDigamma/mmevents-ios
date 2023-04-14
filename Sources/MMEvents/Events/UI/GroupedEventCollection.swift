//
//  GroupedEventCollection.swift
//  moers festival
//
//  Created by Lennart Fischer on 09.05.22.
//  Copyright © 2022 Code for Niederrhein. All rights reserved.
//

import SwiftUI

fileprivate func groupEvents(
    _ events: [EventListItemViewModel]
) -> [(String, [EventListItemViewModel])] {
    
    var keyedEvents: [String: [EventListItemViewModel]] = [:]
    
    for viewModel in events {
        
        let key = viewModel.startDate?
            .format(format: "EEEE, dd.MM.yyyy") ?? "Datum unveröffentlicht"
        
        var kEvent = keyedEvents[key] ?? []
        
        kEvent.append(viewModel)
        
        keyedEvents[key] = kEvent
        
    }
    
    let sorted = keyedEvents.sorted { (a, b) -> Bool in
        return Date.from(a.key, withFormat: "EEEE, dd.MM.yyyy") ??
        Date(timeIntervalSinceNow: pow(86400, 4)) < Date.from(b.key, withFormat: "EEEE, dd.MM.yyyy") ?? Date(timeIntervalSinceNow: pow(86400, 4))
    }
    
    return sorted
    
}

public struct GroupedEventCollection: View {
    
    public let viewModels: [EventListItemViewModel]
    public let containerBackground: Color
    public let onSelectEvent: (Event.ID) -> Void
    
    public init(
        viewModels: [EventListItemViewModel],
        containerBackground: Color = Color(UIColor.systemBackground),
        onSelectEvent: @escaping (Event.ID) -> Void = { _ in }
    ) {
        self.viewModels = viewModels
        self.containerBackground = containerBackground
        self.onSelectEvent = onSelectEvent
    }
    
    private var groupedViewModels: [(String, [EventListItemViewModel])] {
        return groupEvents(viewModels)
    }
    
    public var body: some View {
        
        LazyVStack(alignment: .leading, spacing: 16) {
            
            ForEach(groupedViewModels, id: \.0.self) { (key, data) in
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(key)
                        .fontWeight(.semibold)
//                        .padding(.bottom, 4)
                    
                    Divider()
                        .opacity(0.5)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                    
                        ForEach(data) { event in
                            
                            Button(action: {
                                guard let eventID = event.eventID else { return }
                                onSelectEvent(eventID)
                            }) {
                                EventListItem(viewModel: event)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 20)
                .background(containerBackground)
                
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

struct GroupedEventCollection_Previews: PreviewProvider {
    
    static let events: [EventListItemViewModel] = {
        return [
            Event.stub(withID: 3)
                .setting(\.name, to: "Gamo Singers + tba (ET, DE)")
                .setting(\.startDate, to: Date(timeIntervalSinceNow: -25 * 60))
                .setting(\.endDate, to: Date(timeIntervalSinceNow: 25 * 60))
                .setting(\.place, to: Place.stub(withID: 1)),
            Event
                .stub(withID: 1)
                .setting(\.name, to: "ANNEX 4")
                .setting(\.startDate, to: .init(timeIntervalSinceNow: 60 * 5)),
            Event
                .stub(withID: 2)
                .setting(\.name, to: "Kasper Agnas (SE)")
                .setting(\.startDate, to: .init(timeIntervalSinceNow: 60 * 65)),
            Event.stub(withID: 4),
        ].map { (event: Event) in
            return EventListItemViewModel(
                title: event.name,
                startDate: event.startDate,
                endDate: event.endDate,
                location: event.place?.name
            )
        }
    }()
    
    static var previews: some View {
        GroupedEventCollection(viewModels: events)
            .padding(.vertical)
            .background(Color(UIColor.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
    }
    
}
