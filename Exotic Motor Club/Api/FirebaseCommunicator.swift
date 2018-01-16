//
//  FirebaseCommunicator.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/11/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import Foundation
import Firebase

let dbBase = Database.database().reference()
let storageBase = Storage.storage().reference()

class FirebaseCommunicator {
    
    static let instance = FirebaseCommunicator()
    
    //Database Refrences
    var userRefrence = dbBase.child("users")
    var bookingrefrence = dbBase.child("bookings")
    
    //Storage Refrences
    var storageProfileRef = storageBase.child("profile-pics")
    
    //Generating error
    private func generateError() -> String {
        return "There was a problem with the server!"
    }
    
    func registerUser(uid: String,
                      userData: [String: Any]) {
        userRefrence.child(uid).updateChildValues(userData)
        UserDefaults.standard.setValue("logged", forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func saveData(uid: String,
                  dict: [String: Any]) {
        userRefrence.child(uid).updateChildValues(dict)
    }
    
    func getUserProfileData(uid: String, success: @escaping(User?) -> Void, failure: @escaping(String?) -> Void) {
        
        userRefrence.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dict = snapshot.value else {
                failure(self.generateError())
                return
            }
            
            guard let userModel = User(dict: dict as AnyObject) else {
                failure(self.generateError())
                return
            }
            success(userModel)
        }
    }
    
    func userBooking(uid: String, dict: [String: Any], carType: String) {
        userRefrence.child(uid).child("bookingCarsList").childByAutoId().updateChildValues(["carType": carType, "vaildPurchase": true])
        bookingrefrence.child(uid).childByAutoId().updateChildValues(dict)
    }
}
