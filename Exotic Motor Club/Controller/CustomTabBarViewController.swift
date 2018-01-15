//
//  CustomTabBarViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedColor   = UIColor.tabBarActiveColor
        let unselectedColor = UIColor.lightGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
        selectedIndex = 1
        tabBar.tintColor = UIColor.tabBarActiveColor
        
        tabBar.isTranslucent = false;
    }

}
