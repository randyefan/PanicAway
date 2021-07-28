//
//  CircularProgressBar.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 27/07/21.
//

import UIKit

@IBDesignable
class CircularProgressBar: UIView {
    @IBInspectable var ringWidth: CGFloat = 5

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        createAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        createAnimation()
    }

    private func setupLayers() {
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = UIColor.red.cgColor
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask

        progressLayer.lineWidth = ringWidth
    }

    private func createAnimation() {
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = [CGPoint.zero, CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1)]

        startPointAnimation.repeatCount = Float.infinity
        startPointAnimation.duration = 1

        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = [CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1), CGPoint.zero]

        endPointAnimation.repeatCount = Float.infinity
        endPointAnimation.duration = 1

        progressLayer.add(startPointAnimation, forKey: "startPointAnimation")
        progressLayer.add(endPointAnimation, forKey: "endPointAnimation")
    }

    override func draw(_ rect: CGRect) {
        let arcCenter = CGPoint(x: rect.width / 2, y: (rect.height) * 2)
        let circleRadius = (rect.size.width + 100) / 2
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
        
        backgroundMask.path = circlePath.cgPath
        
        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = UIColor(named: "Main")?.cgColor
        
        layer.addSublayer(progressLayer)
    }
}
