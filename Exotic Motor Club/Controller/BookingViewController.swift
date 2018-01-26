//
//  BookingViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/14/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import Firebase

class BookingViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var bookingDetailsView: UIView!
    @IBOutlet weak var bookVehicleButton: GradientView!
    @IBOutlet weak var rentalDateTextField: CustomTextField!
    @IBOutlet weak var returnDateTextField: CustomTextField!
    @IBOutlet weak var guestName: UITextField!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var tripTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var carBookingDetailsLabel: UILabel!
    
    //MARK: - Proporties
    var car: Car?
    var rentalDate: Date?
    var returnDate: Date?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        guard let car = car, let rentalDate = rentalDate, let returnDate = returnDate else { return }
        carNameLabel.text = car.name
        carPriceLabel.text = "$\(car.price)"
        tripTotalLabel.text = "$\(car.price)"
        totalLabel.text = "$\(car.price + 23)"
        carBookingDetailsLabel.text = car.characteristics
        
        //Date Formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        rentalDateTextField.text = formatter.string(from: rentalDate)
        returnDateTextField.text = formatter.string(from: returnDate)
    }
    
    //MARK: - SetupView
    private func setupView() {
        bookingDetailsView.layer.cornerRadius = 4.0
        bookVehicleButton.layer.cornerRadius = 4.0
        addImageToTextField(textField: rentalDateTextField, imageName: "rental")
        addImageToTextField(textField: returnDateTextField, imageName: "returndate")
    }
    
    private func addImageToTextField(textField: UITextField, imageName: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.isUserInteractionEnabled = false
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    //MARK: - Button Actions
    @IBAction func bookVehicleButtonAction(_ sender: UIButton) {
        
        guard
            let car = car,
            let rentalDate = rentalDate,
            let returnDate = returnDate,
            let uid = Auth.auth().currentUser?.uid,
            let email = Auth.auth().currentUser?.email
                else { return }
        
        guard let guest = guestName.text, guest.count > 0 else {
            presentAlert(message: "Please enter guest name.")
            return
        }
        
        //Date Formatter
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "h:mm a, MMMM dd, yyyy"
        
        let bookingDict = ["bookingCarCost": car.price + 23,
                           "carType": car.name,
                           "guestName": guest,
                           "rentalDate": formatter.string(from: rentalDate),
                           "returnDate": formatter.string(from: returnDate),
                           "location": car.pickupLocation,
                           "userEmail": email,
                           "userUID": uid,
                           "validPurchase": true] as [String : Any]
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            showProgressHUD(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                FirebaseCommunicator.instance.userBooking(uid: uid, dict: bookingDict, carType: car.name)
                self.hideProgressHUD()
                self.presentAlert(title: nil, message: "Vehicle successfully booked!", confirmation: { (alert) in
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        } else {
            noInternetAlert()
        }
    }
}
