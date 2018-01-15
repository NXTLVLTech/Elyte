//
//  BaseViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/11/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {

    //MARK: - Proporties
    private var hud: MBProgressHUD?
    
    //MARK: - MBProgressHUD
    func showProgressHUD(animated: Bool = true, withText text: String? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            guard let unwrappedSelf = self else { return }
            if unwrappedSelf.hud == nil {
                unwrappedSelf.hud = MBProgressHUD.showAdded(to: unwrappedSelf.view, animated: true)
                unwrappedSelf.hud?.removeFromSuperViewOnHide = true
                
            }
            unwrappedSelf.hud?.label.text = text
            unwrappedSelf.view.bringSubview(toFront: unwrappedSelf.hud!)
        }
    }
    
    func hideProgressHUD(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let unwrappedSelf = self else { return }
            unwrappedSelf.hud?.hide(animated: animated)
            unwrappedSelf.hud = nil
        }
    }
    
    //MARK: - No Internet Alert
    func noInternetAlert() {
        hideProgressHUD(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.presentAlert(title: "No internet", message: "No internet connection, please try again..", confirmation: nil)
        }
    }
    
    func tutorialVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "TutorialVC")
        
        appDelegate.window?.switchRootViewController(mainVC)
    }
    
    func loginVCRoot() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        
        appDelegate.window?.switchRootViewController(mainVC)
    }
    
    func mainVCRoot() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainTabVC")
        
        appDelegate.window?.switchRootViewController(mainVC)
    }
    
    func clearNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

}
