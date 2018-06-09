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
    func reloadList(data: [Venue])
}

class VenueView: UIViewController {

    @IBOutlet weak var venueTestField: UITextField!
    @IBOutlet weak var venueTableView: UITableView!
    
    let venuePresenter = VenuePresenter()
    
    var venueList = [Venue]()

    override func viewDidLoad() {
        super.viewDidLoad()
        venuePresenter.requestLocation()
        
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
        let cell = 
    }
    
    
}

extension VenueView: VenueListInterface {
    func showLoading() {
        <#code#>
    }
    
    func hideLoading() {
        <#code#>
    }
    
    func showEmptyView() {
        <#code#>
    }
    
    func reloadList(data: [Venue]) {
        <#code#>
    }
    
    
}



