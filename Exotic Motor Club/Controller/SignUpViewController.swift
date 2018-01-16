//
//  SignUpViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/15/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import SwiftValidator
import Firebase

class SignUpViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: GradientView!
    
    //MARK: - Proporties
    var userDict: [String: AnyObject]?
    var profileImage: UIImage?
    var validator = Validator()
    var allTextFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        registerRules()
    }
    
    //MARK: - Setup View
    private func setupView() {
        signUpButton.layer.cornerRadius = 4.0
    }
    
    //MARK: - Register Rules
    private func registerRules() {
        
        validator.registerField(emailTextField,
                                rules: [RequiredRule(message: "Email is required."),
                                        EmailRule(message: "Your email address is invalid. Please enter a valid address.")])
        
        validator.registerField(passwordTextField, rules: [RequiredRule(message: "Password is required." ), PasswordRule(message: "Password must contain 8 characters, one uppercase one lowercase and one number." )])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        allTextFields.append(emailTextField)
        allTextFields.append(passwordTextField)
    }
    
    //MARK: - Web Services
    private func emailLogin() {
        
        showProgressHUD(animated: true)
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { [weak self] (user, error) in
            guard let unwrappedSelf = self else {
                self?.hideProgressHUD(animated: true)
                return
            }
            
            if error != nil {
                
                if let error = AuthErrorCode(rawValue: error!._code) {
                    switch error {
                    case .invalidEmail:
                        unwrappedSelf.hideProgressHUD(animated: true)
                        unwrappedSelf.presentAlert(message: "This is an invalid email. Try another one.")
                    case .emailAlreadyInUse:
                        unwrappedSelf.hideProgressHUD(animated: true)
                        unwrappedSelf.presentAlert(message: "This email is already in use.")
                    default:
                        unwrappedSelf.hideProgressHUD(animated: true)
                        unwrappedSelf.presentAlert(message: "An unexpected error occured. Please try again.")
                    }
                }
            } else {
                
                if let user = user {
                    
                    guard let email = user.email else {
                        unwrappedSelf.hideProgressHUD()
                        return
                    }
                    unwrappedSelf.saveUserData(uid: user.uid, email: email)
                }
            }
        })
    }
    
    //Saving user profile image and data to firebase
    private func saveUserData(uid: String, email: String) {
        
        guard let profileImage = profileImage else {
            hideProgressHUD()
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        if let imgData = UIImageJPEGRepresentation(profileImage, 0.5) {
            
            FirebaseCommunicator.instance.storageProfileRef.child(uid).putData(imgData, metadata: metadata, completion: { [weak self] (metadata, error) in
                
                guard let unwrappedSelf = self else {
                    self?.hideProgressHUD(animated: true)
                    return
                }
                
                if error != nil {
                    unwrappedSelf.hideProgressHUD(animated: true)
                    unwrappedSelf.presentAlert(message: "Error with uploading an image to Firebase Storage.")
                } else {
                    
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    guard var userDict = unwrappedSelf.userDict else {
                        unwrappedSelf.hideProgressHUD()
                        return
                    }
                    
                    if let url = downloadUrl {
                        
                        userDict["email"] = email as AnyObject
                        userDict["profileLink"] = url as AnyObject
                        
                        FirebaseCommunicator.instance.registerUser(uid: uid, userData: unwrappedSelf.userDict!)
                        unwrappedSelf.hideProgressHUD(animated: true)
                        unwrappedSelf.mainVCRoot()
                    }
                }
            })
        } else {
            hideProgressHUD()
        }
    }
    
    //MARK: - Button Actions
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        loginVCRoot()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            validator.validate(self)
        } else {
            
            noInternetAlert()
        }
    }
    
}

//MARK: - TextField Delegates
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false
    }
}

//MARK: - Validation Delegates
extension SignUpViewController: ValidationDelegate {
    
    func validationSuccessful() {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            emailLogin()
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
