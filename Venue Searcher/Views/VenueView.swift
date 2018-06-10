//
//  ViewController.swift
//  Venue Searcher
//
//  Created by Rauli Puuperä on 08/06/2018.
//  Copyright © 2018 Rauli Puuperä. All rights reserved.
//

import UIKit
import CoreLocation

protocol VenueListInterface {
    func showLoading()
    func hideLoading()
    func showEmptyView()
    func reloadList(venues: [Venue])
}

class VenueView: UIViewController {

    @IBOutlet weak var venueTextField: UITextField!
    @IBOutlet weak var venueTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let venuePresenter = VenuePresenter()
    
    var venueList = [Venue]()

    override func viewDidLoad() {
        super.viewDidLoad()
        venuePresenter.view = self
        venuePresenter.requestLocation()
        
        venueTableView.dataSource = self
        venueTableView.delegate = self
        
    }
    
    @IBAction func venueTextFieldChanged(_ sender: UITextField) {
        self.venuePresenter.search(term: sender.text)
    }
    
    
    func showError(error: Error) {
        let alertController = UIAlertController(title: "Location Error", message: "There was an error accessing current location: \(error.localizedDescription)", preferredStyle: .alert)
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension VenueView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venuecell") as! VenueCell
        
        var venue = venueList[indexPath.row]
        cell.setData(venue: venue, distance: venue.distance(from: venuePresenter.location!))

        return cell
    }
    
    
}

extension VenueView: VenueListInterface {
    func showLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()        
    }
    
    func hideLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    func showEmptyView() {
        venueTableView.isHidden = true
        
    }
    
    func reloadList(venues: [Venue]) {
        venueTableView.isHidden = false
        venueList = venues
        venueTableView.reloadData()
    }
    
    
}



