//
//  AddProfilePictureViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/15/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import Firebase

class AddProfilePictureViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Proporties
    var userDict: [String: AnyObject]!
    var isAdded: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - Setup View
    private func setupView() {
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func imageTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.presentAlert(message: "Camera is not available.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            isAdded = true
            dismiss(animated:true, completion: nil)
        } else {
            self.presentAlert(message: "Error with picking up image. Please choose another one.")
        }
    }
    
    //MARK: - Button Action
    @IBAction func addPictureButtonAction(_ sender: UIButton) {
        guard isAdded == true else {
            presentAlert(message: "Please add profile image.")
            return
        }
        
        performSegue(withIdentifier: "toSignUpVCSegue", sender: nil)
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUpVCSegue" {
            if let dest = segue.destination as? SignUpViewController, let userDict = userDict {
                dest.userDict = userDict
                dest.profileImage = imageView.image
            }
        }
    }
}
