//
//  CircleUIView.swift
//  animated_timer
//
//  Created by Che Chang Yeh on 2021/1/1.
//
import Foundation
import UIKit

class CircleUIView: UIView {
    let shapeLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircleShape(mustBeSquareView: self.bounds.maxX / 10, color1: "#d4fc79", color2: "#96e6a1")
    }
    
    func createCircleShape(mustBeSquareView: CGFloat, color1 c1: String, color2 c2: String) {
        
//        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2)
        let path = UIBezierPath(roundedRect: CGRect(x: mustBeSquareView, y: mustBeSquareView, width: self.bounds.width, height: self.bounds.height), cornerRadius: self.bounds.width / 2)
        
        let trackerLayer = CAShapeLayer()
        
        trackerLayer.path = path.cgPath
        trackerLayer.fillColor = UIColor.clear.cgColor
        trackerLayer.strokeColor = UIColor.lightGray.cgColor
        trackerLayer.lineWidth = 10.0
        self.layer.addSublayer(trackerLayer)
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10.0
        shapeLayer.strokeEnd = 0
        self.layer.addSublayer(shapeLayer)
        
        let gradientLayer = CAGradientLayer()
        let color1 = UIColor(hexString: c1).cgColor
        let color2 = UIColor(hexString: c2).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width * 2, height: self.bounds.width + shapeLayer.lineWidth * 3)
        
        self.layer.addSublayer(gradientLayer)
        gradientLayer.mask = shapeLayer
        
        
    }
    
    func addAnimation(interval: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = interval
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "animation")
        
    }

}
