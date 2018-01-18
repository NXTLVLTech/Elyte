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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    //MARK: - Proporties
    var isAppeared: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAppeared == false {
            animations()
        }
    }
    
    //MARK: - Setup View
    private func setupView() {
        rewardsButton.layer.cornerRadius = 4.0
        shareCodeButton.layer.cornerRadius = 4.0
        shareCodeButton.layer.borderColor = UIColor.white.cgColor
        shareCodeButton.layer.borderWidth = 0.5
    }
    
    private func animations() {
        
        isAppeared = true
        
        //Animate
        imageView.layer.opacity = 0
        titleLabel.layer.opacity = 0
        detailsLabel.layer.opacity = 0
        rewardsButton.layer.opacity = 0
        shareCodeButton.layer.opacity = 0
        
        UIView.animate(withDuration: 0.5) {
            self.imageView.layer.opacity = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
            self.titleLabel.layer.opacity = 1
            self.detailsLabel.layer.opacity = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
            self.rewardsButton.layer.opacity = 1
            self.shareCodeButton.layer.opacity = 1
        }, completion: nil)
    }

}
