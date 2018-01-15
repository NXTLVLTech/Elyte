//
//  SignInViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/11/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import SwiftValidator
import Firebase
import FBSDKLoginKit

class SignInViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    //MARK: - Proporties
    var validator = Validator()
    var allTextFields = [UITextField]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerRules()
    }
    
    //MARK: - Setup View
    private func setupView() {
        
        signInButton.layer.cornerRadius = 4.0
        signInButton.layer.masksToBounds = true
        facebookButton.layer.cornerRadius = 4.0
        facebookButton.layer.masksToBounds = true
    }
    
    private func registerRules() {
        
        validator.registerField(emailTextField,
                                rules: [RequiredRule(message: "Email is required."),
                                        EmailRule(message: "Your email address is invalid. Please enter a valid address.")])
        
        validator.registerField(passwordTextField, rules: [RequiredRule(message: "Password is required.")])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        allTextFields.append(emailTextField)
        allTextFields.append(passwordTextField)
    }
    
    //Email Sign In
    private func emailSignIn() {
        showProgressHUD(animated: true)
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { [weak self] (user, error) in
            
            guard let unwrappedSelf = self else {
                self?.hideProgressHUD(animated: true)
                return
            }
            
            if error == nil {
                
                unwrappedSelf.hideProgressHUD(animated: true)
                UserDefaults.standard.setValue("logged", forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                unwrappedSelf.mainVCRoot()
            } else {
                
                guard let error = AuthErrorCode(rawValue: error!._code) else {
                    unwrappedSelf.hideProgressHUD(animated: true)
                    return
                }
                switch error {
                case .wrongPassword:
                    unwrappedSelf.hideProgressHUD(animated: true)
                    unwrappedSelf.presentAlert(message: "Whoops! That was the wrong password.")
                case .userNotFound:
                    unwrappedSelf.hideProgressHUD(animated: true)
                    unwrappedSelf.presentAlert(message: "User with that email doesn't exist.")
                case .invalidEmail:
                    unwrappedSelf.hideProgressHUD(animated: true)
                    unwrappedSelf.presentAlert(message: "Your email address is invalid. Please enter a valid address.")
                default:
                    unwrappedSelf.hideProgressHUD(animated: true)
                    unwrappedSelf.presentAlert(message: "An unexpected error occured. Please try again.")
                }
            }
        })
    }
    
    //Facebook Sign In
    private func facebookSignIn() {
        showProgressHUD(animated: true)
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logOut()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { [weak self] (result, error) in
            
            guard let unwrappedSelf = self else {
                self?.hideProgressHUD(animated: true)
                return
            }
            
            if error != nil {
                unwrappedSelf.hideProgressHUD(animated: true)
                unwrappedSelf.presentAlert(message: "Unable to authenticate with Facebook. Please try again.")
            } else if result?.isCancelled == true {
                unwrappedSelf.hideProgressHUD(animated: true)
            } else {
                FacebookApi.firebaseCredentialRequest(success: { (facebookUserModel) in
                    
                    guard let fbUser = facebookUserModel else {
                        unwrappedSelf.hideProgressHUD(animated: true)
                        return
                    }
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    unwrappedSelf.firebaseCredentialFacebookLogin(credential: credential, userData: fbUser)
                }, failure: { (error) in
                    
                    unwrappedSelf.hideProgressHUD(animated: true)
                    unwrappedSelf.presentAlert(message: error)
                })
            }
        }
    }
    
    //MARK: - Login Logic with facebook
    private func firebaseCredentialFacebookLogin(credential: AuthCredential, userData: FacebookUserModel) {
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            
            guard let unwrappedSelf = self else {
                self?.hideProgressHUD(animated: true)
                return
            }
            
            if error != nil {
                unwrappedSelf.hideProgressHUD(animated: true)
                unwrappedSelf.presentAlert(message: "Unable to authenticate with Firebase. Please try again.")
            } else {
                guard let userUID = user?.uid else {
                    unwrappedSelf.hideProgressHUD(animated: true)
                    return
                }
                
                FirebaseCommunicator.instance.userRefrence.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //If User is registered with facebook for the first time
                    if !snapshot.hasChild(userUID) {
                        
                        unwrappedSelf.hideProgressHUD(animated: true)
                        
//                        unwrappedSelf.facebookUserData = userData
//                        unwrappedSelf.performSegue(withIdentifier: "toTermsOfUseVCSegue", sender: nil)
                        unwrappedSelf.presentAlert(message: "Success, just created.")
                    } else {
                        
                        UserDefaults.standard.setValue("logged", forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        unwrappedSelf.hideProgressHUD(animated: true)
                        unwrappedSelf.mainVCRoot()
                        unwrappedSelf.presentAlert(message: "Success")
                        
                    }
                })
            }
        }
    }
    
    //MARK: - Button Action
    @IBAction func firebaseUserRegistrationButtonAction() {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            validator.validate(self)
        } else {
            
            noInternetAlert()
        }
    }
    
    
    @IBAction func facebookLoginButtonAction(_ sender: UIButton) {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            facebookSignIn()
        } else {
            noInternetAlert()
        }
    }
}

//MARK: - TextField Delegates
extension SignInViewController: UITextFieldDelegate {
    
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
extension SignInViewController: ValidationDelegate {
    func validationSuccessful() {
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
//            emailSignIn()
            mainVCRoot()
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
