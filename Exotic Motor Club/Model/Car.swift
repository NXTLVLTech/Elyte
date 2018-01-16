//
//  Car.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class Car {
    
    var name: String
    var price: Int
    var mainImage: UIImage
    var numberOfSeats: Int
    var maxSpeed: Int
    var engine: String
    var imageArray: [UIImage]
    var pickupLocation: String
    var details: String
    var topSpeedDetails: String
    
    init(name: String, price: Int, mainImage: UIImage, numberOfSeats: Int, maxSpeed: Int, engine: String, imageArray: [UIImage], pickupLocation: String, details: String, topSpeedDetails: String) {
        
        self.name = name
        self.price = price
        self.mainImage = mainImage
        self.numberOfSeats = numberOfSeats
        self.maxSpeed = maxSpeed
        self.engine = engine
        self.pickupLocation = pickupLocation
        self.imageArray = imageArray
        self.details = details
        self.topSpeedDetails = topSpeedDetails
    }
}
