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
    @IBOutlet weak var grayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 4.0
        priceView.layer.cornerRadius = 11.5
        priceView.clipsToBounds = true
        
        animate()
    }
    
    private func animate() {
        grayView.alpha = 0
        priceView.layer.opacity = 0
        carPriceLabel.layer.opacity = 0
        carNameLabel.layer.opacity = 0
        
        UIView.animate(withDuration: 0.4) {
            self.grayView.alpha = 0.5
        }
        UIView.animate(withDuration: 0.4, delay: 0.4, options: [], animations: {
            self.priceView.layer.opacity = 1
            self.carPriceLabel.layer.opacity = 1
            self.carNameLabel.layer.opacity = 1
        }, completion: nil)
    }
    
    func updateCell(car: Car) {
        carImageView.image = car.mainImage
        carPriceLabel.text = "$\(car.price)"
        carNameLabel.text = car.name
    }
    
}
