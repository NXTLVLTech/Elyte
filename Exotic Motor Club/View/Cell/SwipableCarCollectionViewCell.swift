//
//  SwipableCarCollectionViewCell.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/13/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit
import Kingfisher

class SwipableCarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    
    func updateCell(carImage: String) {
        
        guard let url = URL(string: carImage) else { return }
        carImageView.kf.indicatorType = .activity
        carImageView.contentMode = .scaleAspectFill
        carImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
    
}
