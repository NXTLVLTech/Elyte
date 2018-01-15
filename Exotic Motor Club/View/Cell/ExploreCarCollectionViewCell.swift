//
//  ExploreCarCollectionViewCell.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/12/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class ExploreCarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 4.0
        priceView.layer.cornerRadius = 11.5
        priceView.clipsToBounds = true
    }
    
    func updateCell(car: Car) {
        carImageView.image = car.mainImage
        carPriceLabel.text = "$\(car.price)"
        carNameLabel.text = car.name
    }
    
}
