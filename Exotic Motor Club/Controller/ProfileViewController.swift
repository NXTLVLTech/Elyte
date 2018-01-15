//
//  ProfileViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/13/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Proporties
    var cellTitle = ["FIRST NAME", "LAST NAME", "EMAIL","PASSWORD", "PHONE NUMBER"]
    var profileEditType: EditProfileType?
    var user: User? {
        didSet {
            tableView.reloadData()
            hideProgressHUD()
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        fetchUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Setup View
    private func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
    }
    
    //MARK: - Web services
    private func fetchUserData() {
        
        //Animate
        profileImage.layer.opacity = 0
        UIView.animate(withDuration: 1) {
            self.profileImage.layer.opacity = 1
        }
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
            showProgressHUD(animated: true)
            
            //TODO:
//            guard let uid = Auth.auth().currentUser?.uid else {
//                self.hideProgressHUD()
//                return
//            }
            
            FirebaseCommunicator.instance.getUserProfileData(uid: "123", success: { [weak self] (user) in
                
                guard let user = user, let unwrappedSelf = self else {
                    self?.hideProgressHUD()
                    return
                }
                
                if let imageURL = user.profileImageURL {
                    
                    let url = URL(string: imageURL)!
                    unwrappedSelf.profileImage.kf.indicatorType = .activity
                    unwrappedSelf.profileImage.contentMode = .scaleAspectFill
                    unwrappedSelf.profileImage.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                }
                
                unwrappedSelf.user = user
            }) { [weak self] (error) in
                guard let unwrappedSelf = self else {
                    self?.hideProgressHUD()
                    return
                }
                
                unwrappedSelf.hideProgressHUD()
                unwrappedSelf.presentAlert(message: error!)
            }
        } else {
            
            noInternetAlert()
        }
    }
    
    //MARK: - Button Actions
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettingsVCSegue", sender: nil)
    }
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfileVCSegue" {
            if let dest = segue.destination as? EditProfileViewController, let editType = profileEditType {
                dest.editProfileType = editType
                dest.profileInfoDelegate = self
            }
        }
    }
}

extension ProfileViewController: ProfileInfoDelegate {
    //EditProfleVC delegate
    func returnData(data: String, profileEditingType: EditProfileType) {
        switch profileEditingType {
        case .firstName:
            user?.firstName = data
        case .lastName:
            user?.lastName = data
        case .emailAddress:
            user?.email = data
        case .phoneNumber:
            user?.phoneNumber = data
        case .password:
            break
        }
        tableView.reloadData()
    }
}

//MARK: - TableViewDelegates
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user != nil {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let user = user else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "settingsTableViewCell")
        customizeCell(cell: cell)
        cell.textLabel?.text = cellTitle[indexPath.row]
        
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = user.firstName
        } else if indexPath.row == 1 {
            cell.detailTextLabel?.text = user.lastName
        } else if indexPath.row == 2 {
            cell.detailTextLabel?.text = user.email
        } else if indexPath.row == 3 {
            cell.detailTextLabel?.text = "••••••"
            
        } else {
            if let phoneNumber = user.phoneNumber {
                cell.detailTextLabel?.text = phoneNumber
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        profileEditType = EditProfileType(rawValue: indexPath.row) ?? .firstName
        performSegue(withIdentifier: "toEditProfileVCSegue", sender: nil)
    }
    
    private func customizeCell(cell: UITableViewCell) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 12.0)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 16.0)
        cell.detailTextLabel?.textColor = .white
    }
}
