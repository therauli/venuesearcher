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
    
    var view: VenueView?
    
    private(set) var location: CLLocation?
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func search(term: String?) {
        if let coordinate = location?.coordinate {
            FourSquareService.sharedInstance.delegate = self
            do {
                try FourSquareService.sharedInstance.getVenues(lat: coordinate.latitude, lng: coordinate.longitude, query: term)
            } catch {
                self.view?.showError(error: error)
            }
        }
        
    }
    
}

extension VenuePresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        view?.showError(error: error)
    }
}

extension VenuePresenter: FourSquareServiceDelegate {
    func received(venues: [Venue]) {
        view?.reloadList(venues: venues.sorted {
            $0.distance(from: location!) < $1.distance(from: location!)
        })
    }
    
}
