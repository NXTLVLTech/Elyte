//
//  CustomPhoneNumberTextField.swift
//  FotoPrint
//
//  Created by PRO on 5/29/17.
//  Copyright © 2017 Lazar Vlaovic. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: 0.6).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 1, height: 2.5)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor!])
            attributedPlaceholder = str
        }
    }
    
    // Placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    // Editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
}
