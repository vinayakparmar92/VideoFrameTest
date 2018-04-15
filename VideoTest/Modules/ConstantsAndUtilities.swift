//
//  Constants.swift
//  VideoTest
//
//  Created by Vinayak Parmar on 08/04/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

// MARK: Constants
let kVideoName  = "VerticalVideo"
let kVideoType  = "mp4"
let kAnimationDuration = 0.35
let kFastAnimationDuration = 0.20
let kVideoCollapsedFrameSize = 100
let kPrimaryColor = UIColor.init(red: 142/255,
                                 green: 68/255,
                                 blue: 173/255,
                                 alpha: 1.0)


// MARK: Helper methods
extension UIView {
    var frameForIdentityTransform : CGRect {
        let size = bounds.size;
        let frameForTransformIdentity = CGRect.init(x: center.x - size.width / 2, y: center.y - size.width / 2,
                                                    width: size.width, height: size.height)
        return frameForTransformIdentity
    }
    
    func putCraterOf(radius: CGFloat, circleCenter: CGPoint) {
        let path = CGMutablePath()
        path.addArc(center: circleCenter,
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(bounds)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        layer.mask = maskLayer
        clipsToBounds = true
    }
}
