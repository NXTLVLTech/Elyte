//
//  FacebookApi.swift
//  hitstape
//
//  Created by Lazar Vlaovic on 1/3/18.
//  Copyright © 2018 Lazar Vlaovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookApi {
    
    static func firebaseCredentialRequest(success: @escaping(FacebookUserModel?) -> Void, failure: @escaping(String) -> Void) {
        FBSDKGraphRequest(graphPath: "me",
                          parameters: ["fields": "email, first_name, last_name, picture.type(large), gender"])
            .start { (_, result, error) in
                
                // Check if error has occured
                if error != nil {
                    failure("There was a problem with getting your facebook information.")
                    return
                }
                
                guard let resultJSON = result else { return }
                
                guard let face = FacebookUserModel(dict: resultJSON as AnyObject) else {
                    failure("Error with facebook!")
                    return
                }
                
                guard let _ = face.email else {
                    failure("Your facebook account doesn't have email.")
                    return
                }
                
                success(face)
        }
    }
}

