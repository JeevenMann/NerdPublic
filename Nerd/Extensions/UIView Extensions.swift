//
//  UIView Extensions.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-23.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
extension UIView {
    func roundBottomCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func roundTopCorner() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func roundCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    func makeRounded() {
        self.contentMode = .scaleToFill
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

    func activateShimmer() {

        let gradientLayer = CAGradientLayer()

        let light = UIColor.white.cgColor
        let alpha = UIColor(red: 206 / 255, green: 10 / 255, blue: 10 / 255, alpha: 0.9).cgColor
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [light, alpha, light]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.525)
        gradientLayer.locations = [0.35, 0.50, 0.65]
        self.layer.mask = gradientLayer

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.0
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "shimmer")
    }

    func deactivateSimmer() {
        self.layer.mask = nil
    }
}
