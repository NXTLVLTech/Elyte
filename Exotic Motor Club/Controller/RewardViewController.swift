//
//  RewardViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class RewardViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var rewardsButton: GradientView!
    @IBOutlet weak var shareCodeButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - Setup View
    private func setupView() {
        rewardsButton.layer.cornerRadius = 4.0
        shareCodeButton.layer.cornerRadius = 4.0
        shareCodeButton.layer.borderColor = UIColor.white.cgColor
        shareCodeButton.layer.borderWidth = 0.5
    }

}
