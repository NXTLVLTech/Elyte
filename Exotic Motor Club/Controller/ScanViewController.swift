//
//  ViewController.swift
//  NavBar
//
//  Created by Dunja Maksimovic on 1/12/18.
//  Copyright © 2018 Dunja Maksimovic. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- Properties
    var captureSession = AVCaptureSession()
    var stillImageOutput = AVCaptureStillImageOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var cameraPosition = AVCaptureDevice.Position.back
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSession()
    }
    
    override func viewDidLayoutSubviews() {
        addCornerLines()
    }
    
    func configureSession() {
        captureSession.sessionPreset = .high
        
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(.video)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == cameraPosition) {
                    captureDevice = device
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
    }
    
    func beginSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // TODO should be done better
        previewLayer.frame = cameraView.bounds
        cameraView.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
    }
    
    func addCornerLines() {
        
        // Set size
        let lineLength = 100
        let lineWidth: CGFloat = 1
        
        // Corners
        let minOriginX = Int(cameraView.frame.origin.x)
        let minOriginY = Int(cameraView.frame.origin.y)
        let maxOriginX = minOriginX + Int(cameraView.frame.size.width)
        let maxOriginY = minOriginY + Int(cameraView.frame.size.height)
        
        let corners = ["top left", "top right", "bottom right", "bottom left"]
        
        var startX = 0
        var startY = 0
        var cornerX = 0
        var cornerY = 0;
        var endX = 0;
        var endY = 0;
        
        // Find points for each corner
        for corner in corners {
            
            // Top
            if corner.contains("top") {
                startY = minOriginY + lineLength
                cornerY = minOriginY
                endY = minOriginY
            }
                
                // Bottom
            else if corner.contains("bottom") {
                startY = maxOriginY - lineLength
                cornerY = maxOriginY
                endY = maxOriginY
            }
            
            // Left
            if corner.contains("left") {
                startX = minOriginX
                cornerX = minOriginX
                endX = minOriginX + lineLength
            }
                
                // Right
            else if corner.contains("right") {
                startX = maxOriginX
                cornerX = maxOriginX
                endX = maxOriginX - lineLength
            }
            
            // Create lines
            let path = UIBezierPath()
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: cornerX, y: cornerY))
            path.addLine(to: CGPoint(x: endX, y: endY))
            
            // Set line attributes
            let fillLayer = CAShapeLayer()
            fillLayer.path = path.cgPath
            fillLayer.strokeColor = UIColor.white.cgColor
            fillLayer.fillColor = UIColor.clear.cgColor
            fillLayer.lineWidth = lineWidth
            
            // Add lines to view
            view.layer.addSublayer(fillLayer)
        }
    }
}

// MARK:- CollectionView Delegates
extension ScanViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScanCell", for: indexPath) as! ScanCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

