//
//  EventServiceTest.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import XCTest
import ModernNetworking
import Combine
@testable import MMEvents


final class EventServiceTests: XCTestCase {
    
    var eventService: EventService<Event>! = nil
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        
        let mockLoader = EncodingMockLoader(model: [
            Event.stub(withID: 1).setting(\.name, to: "Event 1"),
            Event.stub(withID: 2),
            Event.stub(withID: 3),
        ])
        
        eventService = EventService<Event>(mockLoader)
        
    }
    
    override func tearDown() {
        eventService = nil
    }
    
    func testIndexNetworkRequest() {
        
        let promise = expectation(description: #function)
        
        eventService.loadEventsFromNetwork()
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        if let error = error as? DecodingError {
                            print(error)
                        }
                        print(error.localizedDescription)
                    default: break
                }
            }, receiveValue: { events in
                XCTAssertEqual(events.count, 3)
                XCTAssertEqual(events[0].name, "Event 1")
                promise.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
        
    }
    
    static var allTests = [
        ("testIndexNetworkRequest", testIndexNetworkRequest),
    ]
}
