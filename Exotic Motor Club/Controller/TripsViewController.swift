//
//  TripsViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var segmentControl: NLSegmentControl!
    @IBOutlet weak var noTripsImageView: UIImageView!
    @IBOutlet weak var noTripsLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        //Showing No Upcoming Trips View
        updateNoTripsView(at: 0)
    }
    
    //MARK: - SetupView
    private func setupView() {
        
        //default segment
        segmentControl.segments = ["Upcoming", "Past"]
        segmentControl.segmentWidthStyle = .fixed
        segmentControl.selectionIndicatorStyle = .fullWidthStripe
        segmentControl.selectionIndicatorColor = .tabBarActiveColor
        segmentControl.selectionIndicatorHeight = CGFloat(2)
        segmentControl.reloadSegments()
        segmentControl.delegate = self
    }

}
//MARK: - NLSegment Index
extension TripsViewController: NLSegmentControlDelegate {
    
    func didChangeSegment(toIndex index: Int) {
        updateNoTripsView(at: index)
    }
    
    private func updateNoTripsView(at index: Int) {
//        noTripsImageView.layer.opacity = 0
//        noTripsLabel.layer.opacity = 0
        if index == 0 {
            
            
            noTripsImageView.image = UIImage(named: "noUpcomingTrips")
            noTripsLabel.text = "No Upcomming Trips"
        } else {
            noTripsImageView.image = UIImage(named: "noPastTrips")
            noTripsLabel.text = "No Past Trips"
        }
    }
}
