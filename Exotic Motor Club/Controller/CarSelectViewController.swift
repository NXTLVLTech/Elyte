//
//  CarSelectViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import MapKit

class CarSelectViewController: BaseViewController, DateReturnProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carSeatsLabel: UILabel!
    @IBOutlet weak var carMaxSpeedLabel: UILabel!
    @IBOutlet weak var carEngineLabel: UILabel!
    @IBOutlet weak var carDescription: UILabel!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var tripDateView: UIView!
    @IBOutlet weak var rentalDateView: UIView!
    @IBOutlet weak var returnDateView: UIView!
    @IBOutlet weak var rentDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    //MARK: - Proporties
    var car: Car?
    var rentDateType: RentDateType?
    var rentalDate: Date? = nil
    var returnDate: Date? = nil
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearNavBar()
        setupView()
    }
    
    //MARK: - SetupView
    private func setupView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        bookNowButton.layer.cornerRadius = 4.0
        tripDateView.layer.borderWidth = 0.5
        tripDateView.layer.borderColor = UIColor.tabBarActiveColor.cgColor
        tripDateView.layer.cornerRadius = 4.0
        
        rentalDateView.layer.cornerRadius = 5.0
        rentalDateView.layer.borderWidth = 0.3
        rentalDateView.layer.borderColor = UIColor.lightGray.cgColor
        rentalDateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rentalDate(_:))))
        
        returnDateView.layer.cornerRadius = 5.0
        returnDateView.layer.borderWidth = 0.3
        returnDateView.layer.borderColor = UIColor.lightGray.cgColor
        returnDateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnDate(_:))))
        
        guard let car = car else { return }
        carPriceLabel.text = "$\(car.price)"
        carNameLabel.text = car.name
        carSeatsLabel.text = "\(car.numberOfSeats) seats"
        carMaxSpeedLabel.text = "\(car.maxSpeed) MPH"
        carEngineLabel.text = car.engine
        carDescription.text = car.details
    }
    
    //MARK: - Open Map With Coordinates
    private func openMapOnLocation() {
        let coordinates = CLLocationCoordinate2DMake(43.071095, -89.355888)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, 50000, 50000)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "665 Williamson Street, Madison, WI, USA coordinates"
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc private func rentalDate(_ sender: UIGestureRecognizer) {
        rentDateType = .rentalDate(maxDate: returnDate)
        performSegue(withIdentifier: "toDatePicker", sender: nil)
    }
    
    @objc private func returnDate(_ sender: UIGestureRecognizer) {
        rentDateType = .returnDate(minDate: rentalDate)
        performSegue(withIdentifier: "toDatePicker", sender: nil)
    }
    
    //MARK: - DatePicker Delegate
    func returnDate(date: Date, dateType: RentDateType) {
        
        //Date Formatter
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "MMMM dd, h:mm a"
        let dateString = formatter.string(from: date)
        
        switch dateType {
        case .rentalDate:
            rentDateLabel.text = "\(dateString)"
            rentalDate = date
        case .returnDate:
            returnDateLabel.text = "\(dateString)"
            returnDate = date
        }
    }
    
    //MARK: - Button Actions
    @IBAction func directionsButtonAction(_ sender: UIButton) {
        openMapOnLocation()
    }
    
    @IBAction func bookCarButtonAction(_ sender: UIButton) {
        guard let _ = returnDate, let _ = rentalDate else {
            presentAlert(message: "Please choose Rent and Return Date.")
            return
        }
        performSegue(withIdentifier: "toBookingVCSegue", sender: nil)
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBookingVCSegue" {
            if let dest = segue.destination as? BookingViewController, let car = car, let returnDate = returnDate, let rentalDate = rentalDate {
                dest.car = car
                dest.rentalDate = rentalDate
                dest.returnDate = returnDate
            }
        } else if segue.identifier == "toDatePicker" {
            if let dest = segue.destination as? DatePickerViewController, let dateType = rentDateType {
                dest.rentDateType = dateType
                dest.delegate = self
            }
        }
    }
}

extension CarSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipableCarCollectionViewCell", for: indexPath) as? SwipableCarCollectionViewCell {
            
            guard let carImage = car?.mainImage else { return UICollectionViewCell() }
            cell.carImage.image = carImage
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
}
