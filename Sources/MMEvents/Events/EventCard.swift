//
//  EventCard.swift
//  
//
//  Created by Lennart Fischer on 11.04.23.
//

import SwiftUI

public struct EventCard: View {
    
    public let data: Data
    
    public var body: some View {
        
        VStack() {
            
            Rectangle()
                .fill(Color.tertiarySystemBackground)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text((data.place ?? "").uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(data.title)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                
                Text(EventUtilities.timeDisplayMode(startDate: data.startDate, endDate: data.endDate).title)
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.secondarySystemBackground)
            .cornerRadius(8)
            .padding(.horizontal, 12)
            .padding(.top, -70)
            
            
        }
        
    }
    
    public struct Data {
        
        public let title: String
        public let place: String?
        public let startDate: Date?
        public let endDate: Date?
        
    }
    
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(data: EventCard.Data(
            title: "Ghost Dogs (DE)",
            place: "Bettenkamper Meer",
            startDate: Date(),
            endDate: Date()
        ))
        .padding()
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
