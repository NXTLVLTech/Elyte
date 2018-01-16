//
//  PhoneNumberViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/14/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneNumberViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    //MARK: - Proporties
    var userDict: [String: AnyObject]?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Setup Views
    private func setupView() {
        
        phoneNumberTextField.delegate = self
    }
    
    //MARK: - Button Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        guard let number = phoneNumberTextField.text, number.count == 12 else {
            presentAlert(message: "Please enter your phone number.")
            return
        }
        guard var userDict = userDict else { return }
        
        userDict["phoneNumber"] = number as AnyObject
        performSegue(withIdentifier: "toAddProfileImageVCSegue", sender: nil)
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddProfileImageVCSegue" {
            if let dest = segue.destination as? AddProfilePictureViewController, let userDict = userDict {
                dest.userDict = userDict
            }
        }
    }
}

//MARK: - TextField Delegates
extension PhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = self.getTextLength(mobileNo: phoneNumberTextField.text!)
        
        if length == 10{
            if range.length == 0{
                return false
            }
        }
        
        if length == 3{
            
            let num : String = self.formatNumber(mobileNo: phoneNumberTextField.text!)
            
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
