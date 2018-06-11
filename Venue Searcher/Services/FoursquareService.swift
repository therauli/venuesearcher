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
    func received(error: Error)
}


enum ServiceError: Error {
    case invalidData(reason: String)
}


// Services that calls Foursquare API
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
        
        Alamofire.request(apiUrl, parameters: parameters).validate(statusCode: 200...200).responseJSON { [unowned self] response in
            switch response.result {
            case .failure(let error):
                self.delegate?.received(error: error)
            case .success:
                do {
                    let venues = try self.parseVenuedata(json: response.result.value as! [String: Any])
                    self.delegate?.received(venues: venues)
                } catch {
                    self.delegate?.received(error: error)
                }
            }
        }
    }
    
    // Used to parse Foursquare API reposnses. Is declared internal to ease testing.
    func parseVenuedata(json: [String: Any]) throws -> [Venue]{
        var venues = [Venue]()

        if  let responseData = json["response"] as? [String: Any], let venuesData = responseData["venues"] as? [[String: Any]] {

            for venueData in venuesData {
                // Check that every piece of data is there. If these fail there is something really wrong in the Foursquare REST API
                guard let name = venueData["name"] as? String else { throw ServiceError.invalidData(reason: "No name in venue Data")}
                guard let venueLocation = venueData["location"] as? [String: Any] else { throw ServiceError.invalidData(reason: "location data is missing") }
                guard let lat = venueLocation["lat"] as? Double else { throw ServiceError.invalidData(reason: "Latitude missing in location data") }
                guard let lng = venueLocation["lng"] as? Double else { throw ServiceError.invalidData(reason: "Longitude missing in location data") }
                guard let distance = venueLocation["distance"] as? Int else { throw ServiceError.invalidData(reason: "Distance missing in location data") }
                
                var category: String?
                var address: String?
                
                if let addressList = venueLocation["formattedAddress"] as? [String] {
                    address = addressList.joined(separator: "\n")
                }
                
                if let categories = venueData["categories"] as? [[String: Any]], let categoryData = categories.first {
                    category = categoryData["shortName"] as? String
                } 
                
                let venue = Venue(name: name, lat: lat, lng: lng, distance: distance, category: category, address: address)
                venues.append(venue)
            }
        }
        return venues
    }
}
