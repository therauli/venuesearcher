//
//  FoursquareServiceTests.swift
//  Venue SearcherTests
//
//  Created by Rauli Puuperä on 11/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import XCTest

class MockServiceDelegate: FourSquareServiceDelegate {
    var venues: [Venue]?
    
    
    func received(venues: [Venue]) {
        self.venues = venues
    }
    
    func received(error: Error) {
        
    }
    
    
}


class FoursquareServiceTests: XCTestCase {
    var mock: MockServiceDelegate!
    
    override func setUp() {
        super.setUp()
        mock = MockServiceDelegate()
        FourSquareService.sharedInstance.delegate = mock
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /// tests that the you can get some venues from the service
    func testBasicFunctionality() {
        let basicExpectation = expectation(description: "Basic test case works")
   
        XCTAssertNoThrow(try FourSquareService.sharedInstance.getVenues(lat: 65.016667, lng: 25.466667, query: ""))
        
        let result = XCTWaiter.wait(for: [basicExpectation], timeout: 10.0)
        
        if result == .timedOut {
            XCTAssertNotNil(mock.venues, "Service should provide some venues always")
        } else {
            XCTFail("Delay was interrupted")
        }
        
    }
    
    func testNotFound() {
        let notFoundExpectation = expectation(description: "not found tests works")
        
        XCTAssertNoThrow(try FourSquareService.sharedInstance.getVenues(lat: 65.016667, lng: 25.466667, query: "lksjghklsjdfghklsjdghfkjlhljkh"))
        
        let result = XCTWaiter.wait(for: [notFoundExpectation], timeout: 10.0)
        
        if result == .timedOut {
            XCTAssertNotNil(mock.venues, "Service should provide a non-optional list with an impossible query")
            XCTAssertEqual(mock.venues?.count, 0, "Service should provide an empty list with an impossible query")
        } else {
            XCTFail("Delay was interrupted")
        }

    }
    
}
