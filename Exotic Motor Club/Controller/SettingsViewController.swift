//
//  SettingsViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/13/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class SettingsViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    
    //MARK: - Proporties
    var cellTitle = ["PUSH NOTIFICATIONS", "PAYMENT INFO", "SUPPORT", "PRIVACY POLICY", "TERMS OF USE"]
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        clearNavBar()
    }
    
    //MARK: - Setup View
    private func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .darkGray
        tableView.tableFooterView = UIView()
        signOutButton.layer.cornerRadius = 4.0
        signOutButton.layer.borderColor = UIColor.white.cgColor
        signOutButton.layer.borderWidth = 0.5
    }
    
    @objc private func onOffToggle(_ sender: UISwitch) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseCommunicator.instance.saveData(uid: uid, dict: ["enableNotifications": sender.isOn])
    }
    
    //MARK: - Button Actions
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            presentYesNoAlert(message: "Are you sure you want to logout?", yesHandler: { (action) in
                self.showProgressHUD(animated: true)
                self.logoutFromFirebase()
            })
        } else {
            noInternetAlert()
        }
    }
}

//MARK: - TableView Delegates
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") {
            
            if indexPath.row != 0 {
                addCheckmark(cell: cell)
            } else {
                onOffSwitchToggle(cell: cell)
            }
            cell.textLabel?.text = cellTitle[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 12.0)
            cell.textLabel?.textColor = .white
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            if let paymentInfoVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyViewController {
                paymentInfoVC.settingType = .paymentInfo
                navigationController?.pushViewController(paymentInfoVC, animated: true)
            }
        } else if indexPath.row == 2 {
            
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                
                self.showSendMailErrorAlert()
            }
        } else if indexPath.row == 3 {
            
            if let privacyPolicyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyViewController {
                
                privacyPolicyVC.settingType = .privacyPolicy
                navigationController?.pushViewController(privacyPolicyVC, animated: true)
            }
        } else if indexPath.row == 4 {
            
            if let termsOfUseVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyViewController {
                
                termsOfUseVC.settingType = .termsOfUse
                
                navigationController?.pushViewController(termsOfUseVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func onOffSwitchToggle(cell: UITableViewCell) {
        
        let toggle = UISwitch()
        toggle.onTintColor = .tabBarActiveColor
        toggle.addTarget(self, action: #selector(onOffToggle(_:)), for: .valueChanged)
        cell.accessoryView = toggle
    }
    
    //Setting custom right side indicator arrow
    private func addCheckmark(cell: UITableViewCell) {
        let image = UIImage(named: "purple")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!));
        checkmark.image = image
        cell.accessoryView = checkmark
    }
}

// MARK: MFMailComposeViewController Delegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@motorclub.com"])
        mailComposerVC.setSubject("Support")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        presentAlert(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.") { (_) in
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
