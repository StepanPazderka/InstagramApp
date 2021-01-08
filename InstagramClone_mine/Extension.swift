//
//  Extension.swift
//  InstagramClone_mine
//
//  Created by Steve on 04/12/2020.
//

import Foundation
import UIKit

extension CALayer {
    func roundCorners(radius: CGFloat) {
        let roundPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        self.mask = maskLayer
    }
}
