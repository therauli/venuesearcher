//
//  Venue.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 08/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import Foundation
import CoreLocation

struct Venue {
    let name: String
    let lat: Double
    let lng: Double

    let category: String?
    let address: String?
    
    private var location: CLLocation {
        return CLLocation(latitude: lat, longitude: lng)
    }
    
    
    init(name: String, lat: Double, lng: Double, category: String?, address: String?) {
        self.name = name
        self.lat = lat
        self.lng = lng
        self.category = category
        self.address = address
    }
    
    func distance(from other: CLLocation) -> Double {
        return other.distance(from: location)
    }
}
