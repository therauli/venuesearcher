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
    let distance: Int

    let category: String?
    let address: String?
    
    init(name: String, lat: Double, lng: Double, distance: Int, category: String?, address: String?) {
        self.name = name
        self.lat = lat
        self.lng = lng
        self.distance = distance
        self.category = category
        self.address = address
    }
    
}
