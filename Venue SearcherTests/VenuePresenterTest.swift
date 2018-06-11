//
//  Venue_SearcherTests.swift
//  Venue SearcherTests
//
//  Created by Rauli Puuperä on 08/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import XCTest
@testable import Venue_Searcher

class MockVenueView: VenueListInterface {
    var isLoading = false
    var isReadyForSearch = false
    var venues: [Venue]?
    
    
    func showLoading() {
        isLoading = true
    }
    func hideLoading() {
        isLoading = false
    }
    
    func reloadList(venues: [Venue]) {
        self.venues = venues
        
    }
    
    func showError(error: Error) {
        
    }
    
    func readyForSearch() {
        isReadyForSearch = true
    }
    
}

class Venue_SearcherTests: XCTestCase {
    
    var presenter: VenuePresenter!
    var view: MockVenueView!
    
    
    override func setUp() {
        super.setUp()
        presenter = VenuePresenter()
        view = MockVenueView()
        presenter.view = view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test the situation where search is called before location has been accessed. The current implementation of the UI does not allow this though
    func testLocationMissing() {
        presenter.search(term: "Hamburger")
        
        XCTAssertEqual(view.isLoading, false, "View indicates loading after search")
        XCTAssertEqual(view.isReadyForSearch, false, "View should not be ready for search before location is set")
    }
    
    /// Test that venue list is empty if the search term is empty
    func testEmptySearchTerm() {
        presenter.search(term: "")
        XCTAssertEqual(view.venues?.count, 0, "Empty search term should always lead to emptu venue list")

    }
    
    /// Test that location is present after request location call
    func testLocation() {
        let locationPresentExpectation = expectation(description: "Location is found")
        presenter.requestLocation()
        let result = XCTWaiter.wait(for: [locationPresentExpectation], timeout: 10.0)

        if result == .timedOut {
            XCTAssertNotNil(presenter.location, "Should have location after call")
        } else {
            XCTFail("Delay was interrupted")
        }
        
    
        
    }
    
    
    
    
    
}
