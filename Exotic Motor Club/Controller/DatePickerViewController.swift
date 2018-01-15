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
    case rentalDate
    case returnDate
}

class DatePickerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Proporties
    var rentDateType: RentDateType?
    var delegate: DateReturnProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        saveButton.layer.cornerRadius = 4.0
        datePicker.minimumDate = Date()
        setupView()
    }
    
    //MARK: - SetupView
    private func setupView() {
        guard let dateType = rentDateType else { return }
        switch dateType {
        case .rentalDate:
            titleLabel.text = "Rental Date and Time"
        case .returnDate:
            titleLabel.text = "Return Date and Time"
        }
    }
    
    @IBAction func returnDateButtonAction(_ sender: UIButton) {
        guard let dateType = rentDateType else { return }
        delegate?.returnDate(date: datePicker.date, dateType: dateType)
        navigationController?.popViewController(animated: true)
    }

}
