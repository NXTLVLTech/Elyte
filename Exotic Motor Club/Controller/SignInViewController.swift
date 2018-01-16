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
import MicroBlink

class SignInViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    //MARK: - Proporties
    var validator = Validator()
    var allTextFields = [UITextField]()
    var userDict: [String: AnyObject]?
    
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
    
    //MARK: - Scanning functions
    func coordinatorWithError(error: NSErrorPointer) -> PPCameraCoordinator? {

        /** 0. Check if scanning is supported */

        if (PPCameraCoordinator.isScanningUnsupported(for: PPCameraType.back, error: error)) {
            return nil;
        }
        
        let settings: PPSettings = PPSettings()
        settings.licenseSettings.licenseKey = "4Q3JJCMH-KPAJ3MYI-GK5EPHWP-YKYOMOFV-4Y4LLZRY-WXTDRNPG-HC26NGHW-UNF4M426"

        //Settings for driver licence scanning
        do {
            let usdlRecognizerSettings = PPUsdlRecognizerSettings()
            settings.scanSettings.add(usdlRecognizerSettings)
        }

        //4. Initialize the Scanning Coordinator object
        let coordinator: PPCameraCoordinator = PPCameraCoordinator(settings: settings)

        return coordinator
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
    
    //MARK: - Button Action
    @IBAction func firebaseUserRegistrationButtonAction() {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            validator.validate(self)
        } else {
            
            noInternetAlert()
        }
    }
    
    //MARK: - Create User scanning licence
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        
        let error: NSErrorPointer = nil
        let coordinator = self.coordinatorWithError(error: error)

        if coordinator == nil {
            let messageString: String = (error!.pointee?.localizedDescription) ?? ""
            let alert = UIAlertController(title: "Warning", message: messageString, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            return
        }

        /** Allocate and present the scanning view controller */
        let scanningViewController: UIViewController = PPViewControllerFactory.cameraViewController(with: self, coordinator: coordinator!, error: nil)
        
        self.present(scanningViewController, animated: true, completion: nil)
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoneNumberVCSegue" {
            if let dest = segue.destination as? PhoneNumberViewController, let userDict = userDict {
                dest.userDict = userDict
            }
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
            emailSignIn()
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

//MARK: - Scanning Camera Delegate
extension SignInViewController: PPScanningDelegate {
    func scanningViewControllerUnauthorizedCamera(_ scanningViewController: UIViewController & PPScanningViewController) {
        presentAlert(message: "In order to scan driving licence please enable camera usage in settings.")
    }
    
    func scanningViewController(_ scanningViewController: UIViewController & PPScanningViewController, didFindError error: Error) {
        presentAlert(message: error.localizedDescription)
    }
    
    func scanningViewControllerDidClose(_ scanningViewController: UIViewController & PPScanningViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func scanningViewController(_ scanningViewController: (UIViewController & PPScanningViewController)?, didOutputResults results: [PPRecognizerResult]) {
        
        guard let scanConroller = scanningViewController else {
            presentAlert(message: "There was an error. Please try again..")
            return
        }
        
        //Scanning results are given in the array of PPRecognizerResult objects.
        // first, pause scanning until we process all the results
        scanConroller.pauseScanning()
        
            var firstName : String = ""
            var lastName : String = ""
            var dateOfBirth: String = ""
            var address: String = ""
        
        // Collect data from the result
        for result in results {
            let usdlResult : PPUsdlRecognizerResult = result as! PPUsdlRecognizerResult
            firstName = usdlResult.getField("Customer First Name")!
            lastName = usdlResult.getField("Customer Family Name")!
            dateOfBirth = usdlResult.getField("Date of Birth")!
            dateOfBirth = String(dateOfBirth.suffix(4))
            address = usdlResult.getField("Full Address")!
        }
        
        let userDict = ["firstName": firstName,
                        "lastName": lastName,
                        "dateOfBirth": dateOfBirth,
                        "address": address]
        
        guard let yearsOld = Int(dateOfBirth) else {
            dismiss(animated: true, completion: {
                self.presentAlert(message: "Problem with formatting years format. Please try again..")
            })
            return
        }
        
        //Checking if user 25 years old
        if checkIf25YearsOld(yearsOld: yearsOld) {
            dismiss(animated: true, completion: {
                self.userDict = userDict as [String : AnyObject]
                self.performSegue(withIdentifier: "toPhoneNumberVCSegue", sender: nil)
            })
            
        } else {
            dismiss(animated: true, completion: {
                self.presentAlert(message: "Turn 25 and come back to sign up.")
            })
        }
    }
    
    
    //Logic for checking if user 25 years old
    private func checkIf25YearsOld(yearsOld: Int) -> Bool {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        if year - yearsOld >= 25 {
            return true
        } else {
            return false
        }
    }
}

