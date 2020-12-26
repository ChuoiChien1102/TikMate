//
//  UILabel+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 9/5/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setBorderWidth(_ boderWidth: CGFloat,_ color: UIColor ) -> Void {
        self.layer.borderWidth = boderWidth
        self.layer.borderColor = color.cgColor
    }
    
    func setPadding(_ rect: CGRect) -> Void {
        let labelInset = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        super.draw(rect.inset(by: labelInset))
    }
    
    func setUnderLine(_ text: String) -> Void {
        let attributeString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.underlineStyle: 1])
        self.attributedText = attributeString
    }
    
    func setAttributeString(_ string: String, font: String, size: Int, color: UIColor) -> Void {
        
        let font = UIFont(descriptor: UIFontDescriptor(name: font, size: CGFloat(size)), size: CGFloat(size))
        let termAttstring = NSMutableAttributedString(attributedString: NSAttributedString(string: string, attributes: [NSAttributedString.Key.strokeColor: color, NSAttributedString.Key.font: font]))
        self.attributedText = termAttstring
    }
    
}
