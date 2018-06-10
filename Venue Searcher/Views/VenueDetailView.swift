//
//  VenueDetailView.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 10/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import UIKit

class VenueDetailView: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var venue: Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if let venue = self.venue {
            titleLabel.text = venue.name
            
            if let category = venue.category {
                categoryLabel.text = category
            } else {
                categoryLabel.isHidden = true
            }
            
            if let address = venue.address {
                addressLabel.text = address
                addressLabel.sizeToFit()
            } else {
                addressLabel.isHidden = true
            }
        }
    }
    
}
