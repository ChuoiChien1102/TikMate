//
//  UIView+Extention.swift
//  TikMate
//
//  Created by ChuoiChien on 12/14/20.
//

import Foundation
import  UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func addGradient(colors: [CGColor], cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = cornerRadius
        
        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    
    func gradientBorder(width: CGFloat,
                        colors: [UIColor],
                        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                        andRoundCornersWithRadius cornerRadius: CGFloat = 0) {
        
        let existingBorder = gradientBorderLayer()
        if  existingBorder == nil {
            let border = CAGradientLayer()
            border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                                  width: bounds.size.width + width, height: bounds.size.height + width)
            border.colors = colors.map { return $0.cgColor }
            border.startPoint = startPoint
            border.endPoint = endPoint
            border.name = UIView.kLayerNameGradientBorder
            
            let mask = CAShapeLayer()
            let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                                  width: bounds.size.width - width, height: bounds.size.height - width)
            mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
            mask.fillColor = UIColor.clear.cgColor
            mask.strokeColor = UIColor.white.cgColor
            mask.lineWidth = width
            
            border.mask = mask
            
            layer.addSublayer(border)
        }
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
}


