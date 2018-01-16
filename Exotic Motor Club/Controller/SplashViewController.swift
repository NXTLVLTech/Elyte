//
//  SplashViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/11/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "tutorialWatched") != nil {
            
            if UserDefaults.standard.object(forKey: "isLoggedIn") != nil {
                self.mainVCRoot()
            } else {
                self.loginVCRoot()
            }
        } else {
            tutorialVC()
        }
    }

}
