//
//  PrivacyPolicyViewController.swift
//  Kure
//
//  Created by Lazar Vlaovic on 1/7/18.
//  Copyright © 2018 Lazar Vlaovic. All rights reserved.
//

import UIKit

enum SettingType {
    case privacyPolicy
    case termsOfUse
    case paymentInfo
}

class PrivacyPolicyViewController: UIViewController {
    
    //MARK: - Propertie
    var privacyPolicy: Bool?
    var settingType: SettingType?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Setup Views
    private func setupView() {
        
            navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 17)!,
                 NSAttributedStringKey.foregroundColor: UIColor.white]
        
        guard let settingType = settingType else { return }
        
        switch settingType {
            
        case .privacyPolicy:
            title = "PRIVACY POLICY"
            
        case .termsOfUse:
            title = "TERMS OF USE"
            
        case .paymentInfo:
            title = "PAYMENT INFO"
        }
    }
}
