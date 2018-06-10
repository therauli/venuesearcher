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
        if venueList.count == 0 {
            return 1
        }
        return venueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if venueList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nodatacell") as! UITableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "venuecell") as! VenueCell
        
        let venue = venueList[indexPath.row]
        cell.setData(venue: venue, distance: venue.distance(from: venuePresenter.location!))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard venueList.count != 0 else {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailView = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! VenueDetailView
            
            detailView.venue = venueList[indexPath.row]
            detailView.modalPresentationStyle = UIModalPresentationStyle.popover
            detailView.preferredContentSize = CGSize(width: 260, height: 200)
            
            let popoverPresentationController = detailView.popoverPresentationController
            popoverPresentationController?.sourceView = cell
            popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: (cell.frame.width), height: cell.frame.height)
            popoverPresentationController?.delegate = self
            popoverPresentationController?.permittedArrowDirections = .any
            
            present(detailView, animated: true, completion: nil)
        }

    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension VenueView: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
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



