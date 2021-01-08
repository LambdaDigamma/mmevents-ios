//
//  EventViewModel.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import MMCommon

public class EventViewModel<Event: BaseEvent> {
    
    open private(set) var event: Event
    private let now: Date
    
    
    public init(event: Event, now: Date = Date()) {
        self.event = event
        self.now = now
    }
    
    open var isActive: Bool {
        
        if ApplicationServerConfiguration.isMoersFestivalModeEnabled {
            
            if let start = event.startDate,
               let end = event.endDate {
                
                if now >= start && now <= end {
                    return true
                } else {
                    return false
                }
                
            }
            
            if let startDate = event.startDate {
                
                let threshold = EventPackageConfiguration
                    .eventActiveMinuteThreshold
                    .converted(to: .seconds)
                    .value
                
                let thresholdMinutesAgo = now.addingTimeInterval(-threshold)
                
                return (thresholdMinutesAgo...now).contains(startDate)
                
            }
            
            return false
            
        } else {
            
            if let start = event.startDate,
               let end = event.endDate {
                
                if now >= start && now <= end {
                    return true
                } else {
                    
                    if start.isToday || end.isToday {
                        return true
                    }
                    
                    return false
                    
                }
                
            }
            
            if let start = event.startDate {
                return start.isToday
            }
            
            if let end = event.endDate {
                return end.isToday
            }
            
        }
        
        return false
        
//        if ApplicationServerConfiguration.isMoersFestivalModeEnabled {
//
//            let current = Date()
//
//            if let start = event.startDate,
//               let end = event.endDate {
//
//                if now >= start && now <= end {
//                    return true
//                } else {
//                    return false
//                }
//
//            }
//
//            if let startDate = event.startDate {
//                print(EventPackageConfiguration.eventActiveMinuteThreshold.converted(to: .seconds).value)
////                print(startDate) >= current)
////                print(startDate)
////                print(event)
//                return startDate <= current.addingTimeInterval(
//                    EventPackageConfiguration.eventActiveMinuteThreshold.converted(to: .seconds).value
//                )
//            }
//
//            return false
//
//        } else {
//
//            if let start = event.startDate,
//               let end = event.endDate {
//
//                if now >= start && now <= end {
//                    return true
//                } else {
//
//                    if start.isToday || end.isToday {
//                        return true
//                    }
//
//                    return false
//
//                }
//
//            }
//
//            if let start = event.startDate {
//                return start.isToday
//            }
//
//            if let end = event.endDate {
//                return end.isToday
//            }
//
//        }
//
//        return false
    }
    
    open var isLongEvent: Bool {
        if let startDate = event.startDate, let endDate = event.endDate {
            
            let calendar = Calendar.current
            
            let date1 = calendar.startOfDay(for: startDate)
            let date2 = calendar.startOfDay(for: endDate)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            
            let days = components.day ?? 0
            
            return days >= 3
            
        } else {
            return false
        }
    }
    
    open var subtitle: String {
        
        if let startDate = event.startDate {
            
            if self.isActive {
                
                print("isactive")
                
                if ApplicationServerConfiguration.isMoersFestivalModeEnabled {
                    return "\(locationRepresentation) • \(String.localized("LiveNow"))"
                } else {
                    return "\(locationRepresentation) • \(String.localized("LiveNow"))"
                }
                
            } else if startDate.isInBeforeInterval(minutes: 59) {
                return "\(locationRepresentation) • \(countdownString)"
            }
            
        }
        
        return "\(locationRepresentation) • \(timeString)"
        
    }
    
    open var detailSubtitle: String {

        var ticket = ""

        if let extras = event.extras {

            if let isFree = extras.isFree, isFree {
                ticket += " • " + String.localized("Free")
            } else if let extraTicket = extras.visitWithExtraTicket, extraTicket {
                ticket += " • " + String.localized("ExtraTicket")
            } else if let festivalTicket = extras.needsFestivalTicket, festivalTicket {
                ticket += " • " + String.localized("NeedsFestivalTicket")
            }

        }

        return subtitle + ticket

    }

    /// This provides information based on the the extra information.
    /// You probably want to override this.
    open var locationRepresentation: String {

        if let isMovingAct = event.extras?.isMovingAct, isMovingAct {
            return "Moving Act"
        }

//        if let location = getLocation() {
//            return location.name
//        } else
        if let locationName = event.extras?.location {
            return locationName
        } else {
            return String.localized("LocationNotKnown")
        }
        
    }

    open var timeString: String {

        let timeComponents = time

//        if let startDate = startDate, startDate.isToday {
//            return "\(timeComponents.day), \(timeComponents.date) \(timeComponents.startTime) - \(timeComponents.endTime)"
//        }

        if let startDate = event.startDate, let endDate = event.endDate {

            if Calendar.current.component(.day, from: startDate) != Calendar.current.component(.day, from: endDate) {
                return "\(timeComponents.day), \(timeComponents.date) \(timeComponents.startTime) - \(startDate.format(format: "EEEE")[...1] + ", " + endDate.format(format: "dd.MM. HH:mm"))"
            } else {
                return "\(timeComponents.day), \(timeComponents.date) \(timeComponents.startTime) - \(timeComponents.endTime)"
            }

        } else if let startDate = event.startDate {

            if Calendar.current.component(.hour, from: startDate) == 0 && Calendar.current.component(.minute, from: startDate) == 0 {
                return "\(timeComponents.day), \(timeComponents.date)"
            } else {
                return "\(timeComponents.day), \(timeComponents.date) \(timeComponents.startTime)"

            }

        } else {
            return String.localized("NotKnownPrompt")
        }

    }

    open var countdownString: String {

        guard let startDate = event.startDate else { return "" }

        return "in \(startDate.minuteInterval())min"

    }
    
    open var time: (day: String, date: String, startTime: String, endTime: String) {

        let day = String(event.startDate?.format(format: "EEEE")[...1] ?? "")
        let date = event.startDate?.format(format: "dd.MM.") ?? ""
        let startTime = event.startDate?.format(format: "HH:mm") ?? ""
        let endTime = event.endDate?.format(format: "HH:mm") ?? ""

        return (day, date, startTime, endTime)

    }

}

