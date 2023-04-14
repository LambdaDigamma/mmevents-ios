//
//  DayEventsView.swift
//  
//
//  Created by Lennart Fischer on 12.04.23.
//

import SwiftUI

public struct DayEventsView: View {
    
    private let date: Date
    
    @StateObject var viewModel: DayEventsViewModel
    @EnvironmentObject var transmitter: TimetableTransmitter
    
    public init(date: Date) {
        self.date = date
        self._viewModel = StateObject(wrappedValue: DayEventsViewModel(date: date))
    }
    
    public var body: some View {
        
        List {
            
            ForEach(viewModel.events) { event in
                Button(action: {
                    if let eventID = event.eventID {
                        transmitter.dispatchShowEvent(eventID)
                    }
                }) {
                    EventListItem(viewModel: event)
                }
            }
            
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.reload()
        }
        
//        ScrollView {
//
//
//
//            Text(date.formatted())
//                .padding()
//
//        }
        
    }
    
}

struct DayEventsView_Previews: PreviewProvider {
    static var previews: some View {
        DayEventsView(date: Date())
            .preferredColorScheme(.dark)
    }
}
