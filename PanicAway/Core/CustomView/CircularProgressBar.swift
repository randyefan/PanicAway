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
        let circlePath = UIBezierPath(roundedRect: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height), cornerRadius: 0)
        let progressPath = UIBezierPath(roundedRect: CGRect(x: 0, y: rect.origin.y, width: rect.width * progress, height: rect.height), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        backgroundMask.path = circlePath.cgPath
        progressLayer.path = progressPath.cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = UIColor(named: "Main")?.cgColor
        
        layer.addSublayer(progressLayer)
    }
}
