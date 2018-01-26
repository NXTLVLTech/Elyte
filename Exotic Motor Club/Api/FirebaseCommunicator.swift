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
    let userRefrence = dbBase.child("users")
    let bookingRefrence = dbBase.child("bookings")
    let vehicleReference = dbBase.child("vehicles")
    
    //Storage Refrences
    let storageProfileRef = storageBase.child("profile-pics")
    let storageVehicleRef = storageBase.child("vehicles")
    
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
        bookingRefrence.child(uid).childByAutoId().updateChildValues(dict)
    }
    
    func getAllCars(success: @escaping([Car]) -> Void, failure: @escaping(String?) -> Void) {
        
        vehicleReference.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let vehicleSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                failure(self.generateError())
                return
            }
            
            var carsArray = [Car]()
            
            for vehicle in vehicleSnapshot {
                
                guard
                    let vehicleDict = vehicle.value as? [String: AnyObject],
                    let vehicle = Car(dict: vehicleDict)
                    else {
                        failure(self.generateError())
                        return
                }
                carsArray.append(vehicle)
            }
            
            success(carsArray)
        }
    }
}
