//
//  ProfileInfoDelegate.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/13/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import Foundation

protocol ProfileInfoDelegate {
    func returnData(data: String, profileEditingType: EditProfileType)
}
