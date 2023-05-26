//
//  CompactDayEventsView.swift
//  
//
//  Created by Lennart Fischer on 12.04.23.
//

import SwiftUI

public struct CompactDayEventsView: View {
    
    private let date: Date
    
    @StateObject var viewModel: DayEventsViewModel
    @EnvironmentObject var transmitter: TimetableTransmitter
    
    public init(date: Date) {
        self.date = date
        self._viewModel = StateObject(wrappedValue: DayEventsViewModel(date: date))
    }
    
    public var body: some View {
        
        ZStack {
            
            List {
                
                ForEach(viewModel.events) { event in
                    Button(action: {
                        if let eventID = event.eventID {
                            transmitter.dispatchShowEvent(eventID)
                        }
                    }) {
                        EventListItem(viewModel: event)
                    }
                    .accessibilityIdentifier("Event-Row-\(event.eventID ?? 0)")
                }
                
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.refresh()
            }
            
        }
        .onAppear {
            viewModel.reload()
        }
        
    }
    
}

//struct DayEventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompactDayEventsView(date: Date())
//            .preferredColorScheme(.dark)
//    }
//}
