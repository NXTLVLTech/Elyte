//
//  PrivacyPolicyViewController.swift
//  Kure
//
//  Created by Lazar Vlaovic on 1/7/18.
//  Copyright © 2018 Lazar Vlaovic. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Propertie
    var privacyPolicy: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = privacyPolicy {
            titleLabel.text = "Privacy Policy"
        } else {
            titleLabel.text = "Terms of Ose"
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
