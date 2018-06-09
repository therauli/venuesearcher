//
//  FoursquareService.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 08/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import Foundation
import Alamofire

protocol FourSquareServiceDelegate {
    func received(venues: [Venue])
}


enum ServiceError: Error {
    case invalidData(reason: String)
}


class FourSquareService {
    
    static let sharedInstance = FourSquareService()
    
    var delegate: FourSquareServiceDelegate?
    
    private let apiUrl = "https://api.foursquare.com/v2/venues/search"
    
    func getVenues(lat: Double, lng: Double, query: String?) throws {
        var parameters = ["client_id": secrets.clientId,
                          "client_secret": secrets.clientSecret,
                          "v": "20180323",
                          "ll": "\(lat),\(lng)"]
        
        if let query = query {
            parameters["query"] = query
        }
        
        Alamofire.request(apiUrl, parameters: parameters).responseJSON { [unowned self] response in
            do {
                try self.parseVenuedata(json: response.result.value as! [String: Any])
            } catch {
                print(error)
            }
        }
    }
    
    func parseVenuedata(json: [String: Any]) throws {
        var venues = [Venue]()
        print(json)
        
        if  let responseData = json["response"] as? [String: Any], let venuesData = responseData["venues"] as? [[String: Any]] {
            var lat: Double
            var lng: Double
            var category: String?
            var address: String?
            for venueData in venuesData {
                let name = venueData["name"] as! String
                if let venueLocation = venueData["location"] as? [String: Any]  {
                    lat = venueLocation["lat"] as! Double
                    lng = venueLocation["lng"] as! Double
                    if let addressList = venueLocation["formattedAddress"] as? [String] {
                        address = addressList.joined(separator: ", ")
                    }
                } else {
                    throw ServiceError.invalidData(reason: "location data is missing")
                }
                
                if let categories = venueData["categories"] as? [[String: Any]], let categoryData = categories.first {
                    category = categoryData["shortName"] as! String
                } 
                
                let venue = Venue(name: name, lat: lat, lng: lng, category: category, address: address)
                venues.append(venue)
            }
        }
        self.delegate?.received(venues: venues)
    }
}
