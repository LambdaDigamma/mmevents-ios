//
//  EventListItem.swift
//  moers festival
//
//  Created by Lennart Fischer on 07.05.22.
//  Copyright © 2022 Code for Niederrhein. All rights reserved.
//

import Core
import SwiftUI

public class EventListItemViewModel: StandardViewModel, Identifiable {
    
    public let id: UUID = .init()
    
    public let eventID: Event.ID?
    
    @Published public var title: String
    @Published public var startDate: Date?
    @Published public var endDate: Date?
    @Published public var location: String?
    @Published public var color: Color = .yellow
    
    public init(
        eventID: Event.ID? = nil,
        title: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        location: String? = nil
    ) {
        self.eventID = eventID
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
    }
    
    public var isActive: Bool {
        return EventUtilities.isActive(
            startDate: startDate,
            endDate: endDate
        )
    }
    
    public var dateRange: ClosedRange<Date>? {
        return EventUtilities.dateRange(
            startDate: startDate,
            endDate: endDate
        )
    }
    
    public var timeDisplayMode: TimeDisplayMode {
        return EventUtilities.timeDisplayMode(
            startDate: startDate,
            endDate: endDate
        )
    }
    
}


public struct EventListItem: View {
    
    @ObservedObject private var viewModel: EventListItemViewModel
    
    public init(viewModel: EventListItemViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            HStack(alignment: .top) {
                
                Text(viewModel.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Spacer()
                
            }
            
            subtitle()
            
        }
        .padding(.leading, 16)
        .background(ZStack {
            Rectangle()
                .fill(viewModel.color)
                .frame(width: 2)
                .cornerRadius(4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading))
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    @ViewBuilder
    private func subtitle() -> some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            switch viewModel.timeDisplayMode {
                    
                case .live:
                    
                    (viewModel.location != nil ? Text("\(viewModel.location ?? "")") : Text(""))
//                        .padding(.leading, 8)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    LiveBadge()
                    
                case .relative:
                    if let startDate = viewModel.startDate {
                        
                        Group {
                            
                            Text(startDate, format: .relative(presentation: .numeric)) +
                            (viewModel.location != nil ?
                             Text(" • \(viewModel.location ?? "")") :
                                Text(""))
                            
                        }.lineLimit(1)
                        
                    }
                    
                case .range:
                    
                    if let dateRange = viewModel.dateRange {
                        
                        Group {
                            
                            Text(dateRange) +
                            (viewModel.location != nil ? Text(" • \(viewModel.location ?? "")") : Text(""))
                            
                        }
                        .lineLimit(1)
                        
                    }
                    
                case .none:
                    Text("Keine Zeit")
                    
            }
            
        }
        .foregroundColor(.secondary)
        .font(.callout)
        
    }
    
}

struct EventListItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let noTime = EventListItemViewModel(
            title: "Ghost Dogs (DE)",
            location: "Aula Gymnasium Filder Benden"
        )
        
        let future = EventListItemViewModel(
            title: "Ghost Dogs (DE)",
            startDate: Date(timeIntervalSinceNow: 160 * 60),
            endDate: Date(timeIntervalSinceNow: 190 * 60),
            location: "Aula Gymnasium Filder Benden"
        )
        
        let upcoming = EventListItemViewModel(
            title: "Matthew Welch solo bagpipes: Matthew Welch plays Braxton, Glass, Welch & More! (US)",
            startDate: Date(timeIntervalSinceNow: 5 * 60),
            endDate: Date(timeIntervalSinceNow: 35 * 60),
            location: "Aula Gymnasium Filder Benden"
        )
        
        upcoming.color = .blue
        
        let activeViewModel = EventListItemViewModel(
            title: "Ghost Dogs (DE)",
            startDate: Date(timeIntervalSinceNow: -5 * 60),
            endDate: Date(timeIntervalSinceNow: 35 * 60),
            location: "Aula Gymnasium Filder Benden"
        )
        
        return Group {
            
            EventListItem(viewModel: noTime)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            EventListItem(viewModel: future)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            EventListItem(viewModel: upcoming)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .environment(\.locale, Locale(identifier: "de"))

            EventListItem(viewModel: activeViewModel)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
        }
        
    }
}
