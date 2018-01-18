//
//  DatePickerViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/14/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

protocol DateReturnProtocol {
    func returnDate(date: Date, dateType: RentDateType)
}

enum RentDateType {
    case rentalDate(maxDate: Date?)
    case returnDate(minDate: Date?)
}

class DatePickerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Proporties
    var rentDateType: RentDateType?
    var delegate: DateReturnProtocol?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - SetupView
    private func setupView() {
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        saveButton.layer.cornerRadius = 4.0
        datePicker.minimumDate = Date()
        
        guard let dateType = rentDateType else { return }
        switch dateType {
        case .rentalDate(let maxDate):
            datePicker.maximumDate = maxDate
            titleLabel.text = "Rental Date and Time"
        case .returnDate(let minDate):
            datePicker.minimumDate = minDate
            titleLabel.text = "Return Date and Time"
        }
    }
    
    //MARK: - Button Actions
    @IBAction func returnDateButtonAction(_ sender: UIButton) {
        guard let dateType = rentDateType else { return }
        delegate?.returnDate(date: datePicker.date, dateType: dateType)
        navigationController?.popViewController(animated: true)
    }

}
