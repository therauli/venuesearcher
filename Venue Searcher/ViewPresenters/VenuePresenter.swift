//
//  VenuePresenter.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 08/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import Foundation
import CoreLocation

class VenuePresenter: NSObject {
    
    var view: VenueListInterface?
    
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
        if term == "" {
            view?.reloadList(venues: [Venue]())
            return
        }

        guard let coordinate = location?.coordinate else {
            return
        }
        
        self.view?.showLoading()
        
        FourSquareService.sharedInstance.delegate = self
        do {
            try FourSquareService.sharedInstance.getVenues(lat: coordinate.latitude, lng: coordinate.longitude, query: term)
        } catch {
            self.view?.hideLoading()
            self.view?.showError(error: error)
        }
        
    }
    
}

extension VenuePresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        view?.readyForSearch()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        view?.showError(error: error)
    }
}

extension VenuePresenter: FourSquareServiceDelegate {
    func received(error: Error) {
        view?.showError(error: error)
    }
    
    func received(venues: [Venue]) {
        view?.hideLoading()
        view?.reloadList(venues: venues.sorted {
            $0.distance(from: location!) < $1.distance(from: location!)
        })
    }
    
}

