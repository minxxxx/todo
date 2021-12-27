//
//  progressCircle.swift
//  MusicRoom
//
//  Created by jdavin on 11/3/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class ProgressCircle: UIView {
    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(_ progress: CGFloat) {
        shapeLayer.strokeEnd = progress
    }
    
    fileprivate func setupView() {
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 45, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 30 / 255, green: 180 / 255, blue: 30 / 255, alpha: 1).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        
        
        layer.addSublayer(shapeLayer)
        
    }
}
