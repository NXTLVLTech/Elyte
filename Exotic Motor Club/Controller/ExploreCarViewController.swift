//
//  ExploreCarViewController.swift
//  Exotic engine Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class ExploreCarViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var segmentControl: NLSegmentControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Proporties
    var carsArray = [Car]()
    var selectedCar: Car?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - SetupView
    private func setupView() {
        
        //default segment
        segmentControl.segments = ["Luxury", "Exotic"]
        segmentControl.segmentWidthStyle = .fixed
        segmentControl.selectionIndicatorStyle = .fullWidthStripe
        segmentControl.selectionIndicatorColor = .tabBarActiveColor
        segmentControl.selectionIndicatorHeight = CGFloat(2)
        segmentControl.reloadSegments()
        segmentControl.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func initialize() {
        let car1 = Car(name: "Mercedes AMG S63", price: 1294, mainImage: #imageLiteral(resourceName: "mercedesAmg"), numberOfSeats: 2, maxSpeed: 230, engine: "12.5L V12", imageArray: [#imageLiteral(resourceName: "mercedesAmg"), #imageLiteral(resourceName: "mercedesAmg"), #imageLiteral(resourceName: "mercedesAmg")], pickupLocation: "665 Williamson Street, Madison, WI, USA", details: "Experience true speed with a AMG power.")
        let car2 = Car(name: "Rolls Royce Ghost ", price: 699, mainImage: #imageLiteral(resourceName: "RollsRoyce"), numberOfSeats: 4, maxSpeed: 217, engine: "12.5L V12", imageArray: [#imageLiteral(resourceName: "RollsRoyce"), #imageLiteral(resourceName: "RollsRoyce"), #imageLiteral(resourceName: "RollsRoyce")], pickupLocation: "665 Williamson Street, Madison, WI, USA", details: "Experience true class and style with a Rolls-Royce Ghost.")
        let car3 = Car(name: "Bentley GT", price: 500, mainImage: #imageLiteral(resourceName: "bentley"), numberOfSeats: 4, maxSpeed: 220, engine: "12.5L V12", imageArray: [#imageLiteral(resourceName: "bentley"), #imageLiteral(resourceName: "bentley"), #imageLiteral(resourceName: "bentley")], pickupLocation: "665 Williamson Street, Madison, WI, USA", details: "Luxurious and power at the same time.")
        let car4 = Car(name: "Dodge Challenger", price: 700, mainImage: #imageLiteral(resourceName: "dodgeChallenger"), numberOfSeats: 4, maxSpeed: 199, engine: " 6.4L V8", imageArray: [#imageLiteral(resourceName: "dodgeChallenger"), #imageLiteral(resourceName: "dodgeChallenger"), #imageLiteral(resourceName: "dodgeChallenger")], pickupLocation: "665 Williamson Street, Madison, WI, USA", details: "American Muscle Style for good experience.")
        carsArray.append(car1)
        carsArray.append(car2)
        carsArray.append(car3)
        carsArray.append(car4)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCarSelectVCSegue" {
            if let dest = segue.destination as? CarSelectViewController, let car = selectedCar {
                dest.car = car
            }
        }
    }
}

extension ExploreCarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCarCollectionViewCell", for: indexPath) as? ExploreCarCollectionViewCell {
            
            cell.updateCell(car: carsArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCar = carsArray[indexPath.row]
        performSegue(withIdentifier: "toCarSelectVCSegue", sender: nil)
    }
}

extension ExploreCarViewController: NLSegmentControlDelegate {
    
    func didChangeSegment(toIndex index: Int) {
        debugPrint(index)
    }
}
