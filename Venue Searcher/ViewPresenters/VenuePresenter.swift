//
//  VenuePresenter.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 08/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import Foundation
import CoreLocation

protocol VenueFoo {
    
}

class VenuePresenter: NSObject {
    
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()

    }
}

extension VenuePresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("UP")
        for location in locations {
            print(location)
            let coordinate = location.coordinate
            FourSquareService.sharedInstance.delegate = self
            do {
                try FourSquareService.sharedInstance.getVenues(lat: coordinate.latitude, lng: coordinate.longitude)
            } catch {
                print("OHNO")
            }

            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("foo2")
        
    }
}

extension VenuePresenter: FourSquareServiceDelegate {
    func received(venues: [Venue]) {
        print(venues)
    }
    
}

