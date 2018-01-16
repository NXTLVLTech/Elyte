//
//  SettingsViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/13/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

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
        debugPrint(sender.isOn)
    }
    
    //MARK: - Button Actions
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        showProgressHUD(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.logoutFromFirebase()
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
        
        if indexPath.row == 2 {
            let urlEMail = NSURL(string: "mailto:support@motorclub.com")
            
            if UIApplication.shared.canOpenURL(urlEMail! as URL) {
                UIApplication.shared.openURL(urlEMail! as URL)
            }
        } else if indexPath.row == 3 {
            
            if let privacyPolicyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyViewController {
                privacyPolicyVC.privacyPolicy = true
                present(privacyPolicyVC, animated: true, completion: nil)
            }
        } else if indexPath.row == 4 {
            
            if let privacyPolicyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyViewController {
                present(privacyPolicyVC, animated: true, completion: nil)
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
