//
//  TimetableScreen.swift
//  
//
//  Created by Lennart Fischer on 11.04.23.
//

import SwiftUI

public struct TimetableScreen: View {
    
    @State var search = ""
    @AppStorage("currentEventDisplayMode") private var displayMode: DailyEventsDisplayMode = .compact
    
    @StateObject var viewModel = TimetableViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        
        ZStack {
            
            switch displayMode {
                case .compact:
                    CompactEventsView(viewModel: viewModel)
                case .images:
                    images()
                case .venueGrid:
                    VenueEventsGrid()
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Section {
                    Menu {
                        Picker(selection: $displayMode, label: Text("Sorting options")) {
                            ForEach(DailyEventsDisplayMode.allCases) { (displayMode: DailyEventsDisplayMode) in
                                Text(displayMode.title)
                                    .tag(displayMode)
                                    .id(displayMode.rawValue)
                            }
                        }
                    }
                    label: {
                        Label("Add", systemImage: "rectangle.grid.1x2")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationTitle(Text("Spielplan"))
        
    }
    
    @ViewBuilder private func images() -> some View {
        
        LazyVStack(spacing: 20) {
            
            EventCard(data: .init(
                title: "Editrix (DE)",
                place: "ENNI Eventhalle",
                startDate: Date(),
                endDate: Date(timeIntervalSinceNow: 60 * 30))
            )
            
            EventCard(data: .init(
                title: "Editrix (DE)",
                place: "ENNI Eventhalle",
                startDate: Date(),
                endDate: Date(timeIntervalSinceNow: 60 * 30))
            )
            
        }
        .padding(.horizontal)
        
    }
    
}

struct TimetableScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimetableScreen()
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
        }
        .accentColor(.yellow)
    }
}
