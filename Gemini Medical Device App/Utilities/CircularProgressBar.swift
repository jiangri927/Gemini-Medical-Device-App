//
//  CircularProgressBar.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 10.0, *)
@available(iOS 10.0, *)
class CircularProgressBar: UIView {
    // MARK: awakeFromNib

    var delegate: circularProgressStatus?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
        textin = "0"
    }

    // MARK: Public

    var number = Int()
    public var numberA: Int {
        return number
    }

    public var lineWidth: CGFloat = 50 {
        didSet {
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }

    public var labelSize: CGFloat = 20 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.textColor = .white
            label.sizeToFit()
            configLabel()
        }
    }

    public var safePercent: Int = 100 {
        didSet {
            setForegroundLayerColorForSafePercent()
        }
    }

    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        var progress: Double {
            if progressConstant > 1 { return 1 }
            else if progressConstant < 0 { return 0 }
            else { return progressConstant }
        }

        foregroundLayer.strokeEnd = CGFloat(progress)

        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
        }

        var currentTime: Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentTime >= 2 {
                timer.invalidate()
            } else {
                currentTime += 0.05
                let percent = currentTime / 2 * 100
                self.label.text = "\(Int(progress * percent))%"
                self.number = Int(progress * percent)
                self.setForegroundLayerColorForSafePercent()
                self.configLabel()
                self.delegate?.Status(Int(percent))
            }
        }

        timer.fire()
    }

    // MARK: Private

    private var label = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var textin = String()
    private var radius: CGFloat {
        if frame.width < frame.height { return (frame.width - lineWidth) / 2 }
        else { return (frame.height - lineWidth) / 2 }
    }

    private var pathCenter: CGPoint { return convert(center, from: superview) }
    private func makeBar() {
        layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }

    private func drawBackgroundLayer() {
        let path = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        backgroundLayer.path = path.cgPath
        backgroundLayer.strokeColor = UIColor.black.cgColor
        //      self.backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineWidth = lineWidth - (lineWidth * 20 / 100)
        backgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backgroundLayer)
    }

    private func drawForegroundLayer() {
        let startAngle = (-CGFloat.pi / 2)
        let endAngle = 2 * CGFloat.pi + startAngle

        let path = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = UIColor.yellow.cgColor
        foregroundLayer.strokeEnd = 0

        layer.addSublayer(foregroundLayer)
    }

    private func makeLabel(withText text: String) -> String {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        label.text = "\(text)%"
        label.font = UIFont.systemFont(ofSize: labelSize)

        textin = text
        label.sizeToFit()
        label.center = pathCenter
        return textin
    }

    private func configLabel() {
        label.sizeToFit()
        label.center = pathCenter
    }

    private func setForegroundLayerColorForSafePercent() {
        if Int(textin)! >= safePercent {
            foregroundLayer.strokeColor = UIColor.green.cgColor
        } else {
            foregroundLayer.strokeColor = UIColor.yellow.cgColor
        }
    }

    private func setupView() {
        makeBar()
        addSubview(label)
    }

    // Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of _: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
}
