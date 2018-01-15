//
//  FacebookUserModel.swift
//  hitstape
//
//  Created by Lazar Vlaovic on 1/3/18.
//  Copyright © 2018 Lazar Vlaovic. All rights reserved.
//

import Foundation

class FacebookUserModel {
    
    var email: String?
    var firstName: String
    var lastname: String
    var gender: String
    var profileImageURL: String?
    
    init?(dict: AnyObject) {
        
        guard
            let email = dict["email"] as? String,
            let firstName = dict["first_name"] as? String,
            let lastName = dict["last_name"] as? String,
            let gender = dict["gender"] as? String
            else { return nil }
        
        self.email = email
        self.firstName = firstName
        self.lastname = lastName
        self.gender = gender

        
        if let profileLink = dict["picture"] as? String {
            self.profileImageURL = profileLink
        }
    }
}
