//
//  User.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/13/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String?
    var profileImageURL: String?
    
    init?(dict: AnyObject) {
        
        guard
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let email = dict["email"] as? String
            else { return nil }
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        
        if let phoneNumber = dict["phoneNumber"] as? String {
            self.phoneNumber = phoneNumber
        }
        
        if let profileImageURL = dict["profileLink"] as? String {
            self.profileImageURL = profileImageURL
        }
    }
}
