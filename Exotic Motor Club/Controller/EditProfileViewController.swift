//
//  EditProfileViewController.swift
//  Kure
//
//  Created by Lazar Vlaovic on 1/5/18.
//  Copyright © 2018 Lazar Vlaovic. All rights reserved.
//

import UIKit
import SwiftValidator
import Firebase

enum EditProfileType: Int {
    case firstName = 0
    case lastName
    case emailAddress
    case password
    case phoneNumber
    
    
    func getString() -> String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .emailAddress:
            return "Email"
        case .phoneNumber:
            return "Phone Number"
        case .password:
            return "Password"
        }
    }
}

class EditProfileViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButtonAction: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Proporties
    var validator = Validator()
    var editProfileType: EditProfileType?
    var allTextFields = [UITextField]()
    var profileInfoDelegate: ProfileInfoDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        guard let type = editProfileType else { return }
        profileTypeSetup(type: type)
        
    }
    
    //MARK: - Setup Views
    private func setupView() {
        textField.delegate = self
        mainView.layer.cornerRadius = 34.0
        textField.becomeFirstResponder()
        saveButtonAction.layer.cornerRadius = 4.0
    }
    
    private func rulesRegister(type: EditProfileType) {
        
        validator.registerField(textField, rules: [RequiredRule(message: "Field is required.")])
        
        switch type {
        case .emailAddress:
            validator.registerField(textField, rules: [EmailRule(message: "Please enter a valid address.")])
        case .password:
            validator.registerField(textField, rules: [PasswordRule(message: "Password must contain 8 characters, one uppercase one lowercase and one number." )])
        default:
            break
        }
        
        allTextFields.append(textField)
    }
    
    private func profileTypeSetup(type: EditProfileType) {
        titleLabel.text = type.getString()
        rulesRegister(type: type)
        
        //Setup Keyboard Type
        switch type {
        case .emailAddress:
            textField.keyboardType = .emailAddress
        case .phoneNumber:
            textField.keyboardType = .numberPad
        case .password:
            textField.isSecureTextEntry = true
        default:
            break
        }
    }
    
    //MARK: - Save Functions
    private func updateFullName(uid: String) {
        let dict = ["firstName": textField.text!] as [String: Any]
        FirebaseCommunicator.instance.saveData(uid: uid, dict: dict)
        profileInfoDelegate?.returnData(data: textField.text!, profileEditingType: .firstName)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateLastName(uid: String) {
        let dict = ["lastName": textField.text!] as [String: Any]
        FirebaseCommunicator.instance.saveData(uid: uid, dict: dict)
        profileInfoDelegate?.returnData(data: textField.text!, profileEditingType: .lastName)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateEmailAddress(uid: String) {
        
        let currentUser = Auth.auth().currentUser
        
        showProgressHUD(animated: true)
        
        currentUser?.updateEmail(to: textField.text!, completion: { [weak self] (error) in
            
            guard let unwrappedSelf = self else {
                self?.hideProgressHUD()
                return
            }
            
            if let err = error {
                unwrappedSelf.hideProgressHUD()
                unwrappedSelf.presentAlert(message: (err.localizedDescription))
            } else {
                unwrappedSelf.hideProgressHUD()
                let dict = ["email": unwrappedSelf.textField.text!] as [String: Any]
                FirebaseCommunicator.instance.saveData(uid: uid, dict: dict)
                unwrappedSelf.profileInfoDelegate?.returnData(data: unwrappedSelf.textField.text!, profileEditingType: .emailAddress)
                unwrappedSelf.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func updatePhoneNumber(uid: String) {
        
        guard let number = textField.text, number.count == 12 else {
            presentAlert(message: "Please enter your phone number.")
            return
        }
        let dict = ["phoneNumber": number] as [String: Any]
        FirebaseCommunicator.instance.saveData(uid: uid, dict: dict)
        profileInfoDelegate?.returnData(data: textField.text!, profileEditingType: .phoneNumber)
        dismiss(animated: true, completion: nil)
    }
    
    private func updatePassword(uid: String) {
        
        let currentUser = Auth.auth().currentUser
         showProgressHUD(animated: true)
        
        currentUser?.updatePassword(to: textField.text!, completion: { [weak self] (error) in
            
            guard let unwrappedSelf = self else {
                self?.hideProgressHUD()
                return
            }
            
            if let err = error {
                unwrappedSelf.hideProgressHUD()
                unwrappedSelf.presentAlert(message: err.localizedDescription)
            } else {
                unwrappedSelf.hideProgressHUD()
                unwrappedSelf.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    //MARK: - Button Actions
    @IBAction func dismissButtonActio(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserDataButtonAction(_ sender: UIButton) {
        
        validator.validate(self)
    }
}

//MARK: - Validation Delegates
extension EditProfileViewController: ValidationDelegate {
    func validationSuccessful() {
        
        //TODO:
        guard let uid =  Auth.auth().currentUser?.uid else { return }
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            guard let type = editProfileType else { return }
            switch type {
            case .firstName:
                updateFullName(uid: uid)
            case .lastName:
                updateLastName(uid: uid)
            case .emailAddress:
                updateEmailAddress(uid: uid)
            case .phoneNumber:
                updatePhoneNumber(uid: uid)
            case .password:
                updatePassword(uid: uid)
            }
        } else {
            noInternetAlert()
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        
        for field in allTextFields {
            for error in errors where error.1.field === field {
                self.presentAlert(message: error.1.errorMessage)
                return
            }
        }
    }
}

//MARK: - TextField Delegates
extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if editProfileType == .phoneNumber {
            let length = self.getTextLength(mobileNo: textField.text!)
            
            if length == 10{
                if range.length == 0{
                    return false
                }
            }
            
            if length == 3{
                
                let num : String = self.formatNumber(mobileNo: textField.text!)
                
                textField.text = num + "-"
                if(range.length > 0){
                    textField.text = (num as NSString).substring(to: 3)
                }
            }
            else if length == 6{
                
                let num : String = self.formatNumber(mobileNo: textField.text!)
                
                let prefix  = (num as NSString).substring(to: 3)
                let postfix = (num as NSString).substring(from: 3)
                
                textField.text = prefix + "-" + postfix + "-"
                
                if range.length > 0{
                    textField.text = prefix + postfix
                }
            }
            return true
        }
        
        
        return true
    }
    
    private func getTextLength(mobileNo: String) -> NSInteger{
        
        var str : NSString = mobileNo as NSString
        str = str.replacingOccurrences(of: "(", with: "") as NSString
        str = str.replacingOccurrences(of: ")", with: "") as NSString
        str = str.replacingOccurrences(of: " ", with: "") as NSString
        str = str.replacingOccurrences(of: "-", with: "") as NSString
        str = str.replacingOccurrences(of: "+", with: "") as NSString
        
        return str.length
    }
    
    private func formatNumber(mobileNo: String) -> String{
        var str : NSString = mobileNo as NSString
        str = str.replacingOccurrences(of: "(", with: "") as NSString
        str = str.replacingOccurrences(of: ")", with: "") as NSString
        str = str.replacingOccurrences(of: " ", with: "") as NSString
        str = str.replacingOccurrences(of: "-", with: "") as NSString
        str = str.replacingOccurrences(of: "+", with: "") as NSString
        
        if str.length > 10{
            str = str.substring(from: str.length - 10) as NSString
        }
        
        return str as String
    }
}
