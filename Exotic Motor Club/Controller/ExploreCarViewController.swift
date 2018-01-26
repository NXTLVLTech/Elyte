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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        getAllCars()
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
    
    //MARK: - Web Services
    private func getAllCars() {
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            showProgressHUD(animated: true)
            
            FirebaseCommunicator.instance.getAllCars(success: { [weak self] (carsArray) in
                
                guard let unwSelf = self else {
                    self?.hideProgressHUD()
                    return
                }
                
                unwSelf.carsArray = carsArray
                unwSelf.collectionView.reloadData()
                unwSelf.hideProgressHUD()
            }) { [weak self] (error) in
                
                guard let unwSelf = self, let error = error else {
                    self?.hideProgressHUD()
                    return
                }
                
                unwSelf.hideProgressHUD()
                unwSelf.presentAlert(message: error)
            }
        } else {
            
            noInternetAlert()
        }
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
        animateCollectionView()
    }
    
    private func animateCollectionView() {
        collectionView.layer.opacity = 0
        UIView.animate(withDuration: 0.7) {
            self.collectionView.layer.opacity = 1
        }
    }
}
