//
//  UIViewController+PresentAlert.swift
//  Where to go?
//
//  Created by Lazar Vlaovic on 10/10/17.
//  Copyright © 2017 Lazar Vlaovic. All rights reserved.
//
import UIKit

extension UIViewController {
    
    func presentAlert(title: String? = nil,
                        message: String,
                        confirmation: ((UIAlertAction) -> Void)? = nil) {
        
        let okAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        okAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: confirmation))
        
        self.present(okAlert, animated: true, completion: nil)
    }
    
    func presentLoginAlert(login: @escaping(UIAlertAction) -> Void) {
        
        let loginAlert = UIAlertController(title: "User required", message: "You have to login first in order to see this profile screen.", preferredStyle: .alert)
        
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        loginAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: login))
        
        self.present(loginAlert, animated: true, completion: nil)
    }
    
    func presentCameraPhotoLibraryAlert(camera: @escaping(UIAlertAction) -> Void,
                                        library: @escaping(UIAlertAction) -> Void,
                                        cancel:((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: camera))
        alert.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: library))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentYesNoAlert(title: String? = nil,
                           message: String,
                           yesHandler: @escaping ((UIAlertAction) -> Void),
                           noHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: yesHandler))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: noHandler))
        alert.view.tintColor = UIColor.tabBarActiveColor
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
