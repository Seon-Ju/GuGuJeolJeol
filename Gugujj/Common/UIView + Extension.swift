//
//  UIView + Extension.swift
//  Gugujj
//
//  Created by EunTak Oh on 2022/05/27.
//

import Foundation
import UIKit

extension UIView {
    func addGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.opacity = 0.6
        gradient.locations = [0.45, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
