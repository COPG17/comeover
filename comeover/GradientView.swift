//
//  GradientView.swift
//  comeover
//
//  Created by Vincent Joel Morales on 12/6/22.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
}
