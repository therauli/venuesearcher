//
//  VenueCell.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 09/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {

    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(venue: Venue, distance: Double) {
        self.venueLabel.text = venue.name
        
        let formatted = NSString(format: "%.1fm", distance)

        self.distanceLabel.text = String(formatted)
    }

}
