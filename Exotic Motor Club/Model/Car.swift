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
    var imageURL: String
    var numberOfSeats: Int
    var maxSpeed: Int
    var engine: String
    var pickupLocation: String
    var details: String
    var characteristics: String
    
    init?(dict: [String: AnyObject]) {
        
        guard
            let name = dict["name"] as? String,
            let price = dict["price"] as? Int,
            let imageURL = dict["image"] as? String,
            let numberOfSeats = dict["numOfSeats"] as? Int,
            let maxSpeed = dict["maxSpeed"] as? Int,
            let engine = dict["engine"] as? String,
            let pickupLocation = dict["pickupLocation"] as? String,
            let details = dict["details"] as? String,
            let characteristics = dict["characteristics"] as? String
            else { return nil }
        
        self.name = name
        self.price = price
        self.imageURL = imageURL
        self.numberOfSeats = numberOfSeats
        self.maxSpeed = maxSpeed
        self.engine = engine
        self.pickupLocation = pickupLocation
        self.details = details
        self.characteristics = characteristics
    }
}
