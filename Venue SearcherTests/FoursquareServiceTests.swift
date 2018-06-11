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
    var wasThereError = false
    
    
    func received(venues: [Venue]) {
        self.venues = venues
    }
    
    func received(error: Error) {
        wasThereError = true
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
            XCTAssertEqual(mock.wasThereError, false, "Service should not throw an error")
        } else {
            XCTFail("Delay was interrupted")
        }
        
    }
    
    /// tests that you get an empty list if the query does not make sense.
    func testNotFound() {
        let notFoundExpectation = expectation(description: "not found tests works")
        
        XCTAssertNoThrow(try FourSquareService.sharedInstance.getVenues(lat: 65.016667, lng: 25.466667, query: "lksjghklsjdfghklsjdghfkjlhljkh"))
        
        let result = XCTWaiter.wait(for: [notFoundExpectation], timeout: 10.0)
        
        if result == .timedOut {
            XCTAssertNotNil(mock.venues, "Service should provide a non-optional list with an impossible query")
            XCTAssertEqual(mock.venues?.count, 0, "Service should provide an empty list with an impossible query")
            XCTAssertEqual(mock.wasThereError, false, "Service should not throw an error")
        } else {
            XCTFail("Delay was interrupted")
        }
    }
    
    /// Test that parser works if the response body is empty. This is not a real-life screnari according the API docs
    func testParserEmptyResponse() {
        let venues = try? FourSquareService.sharedInstance.parseVenuedata(json: [String:Any]())
        XCTAssertEqual(venues?.count, 0, "Even with empty response we should get an empty list")
    }
    
    /// Test that parser works even if the venues is empty
    func testParserNoNameInResponse() {
        let data = ["response": ["venues": [["kissa": 3.5]]]]
        do {
            let _ = try FourSquareService.sharedInstance.parseVenuedata(json: data)
            XCTFail("Should throw an error with invalid data")
        } catch ServiceError.invalidData(let message) {
            XCTAssertEqual(message, "No name in venue Data", "Wrong error thrown")
        } catch {
            XCTFail("Wrong error thrown")
        }
    }
    
    
    
}
