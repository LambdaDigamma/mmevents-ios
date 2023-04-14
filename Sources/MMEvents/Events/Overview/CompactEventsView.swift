//
//  CompactEventsView.swift
//  
//
//  Created by Lennart Fischer on 11.04.23.
//

import SwiftUI

public struct CompactEventsView: View {
    
    @ObservedObject var viewModel: TimetableViewModel
    
    public init(viewModel: TimetableViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        
        VStack {
            
            VStack(spacing: 0) {
                
                DaySelector(selectedDate: $viewModel.selectedDate, dates: viewModel.dates)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                Divider()
                
            }
            
            TabView(selection: $viewModel.selectedDate) {
                
                ForEach(viewModel.dates, id: \.self) { date in
                    
                    DayEventsView(date: date)
                        .tag(date)
                    
                }
                
            }.tabViewStyle(.page(indexDisplayMode: .never))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}

struct CompactEventsView_Previews: PreviewProvider {
    static var previews: some View {
        CompactEventsView(viewModel: TimetableViewModel())
            .preferredColorScheme(.dark)
    }
}
