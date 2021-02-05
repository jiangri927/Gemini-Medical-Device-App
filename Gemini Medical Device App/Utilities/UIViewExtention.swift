//
//  UIViewExtention.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {}

@IBDesignable
class DesignableButton: UIButton {}

@IBDesignable
class DesignableLabel: UILabel {}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

// Gesture extention

extension UIGestureRecognizer {
    @discardableResult convenience init(addToView targetView: UIView,
                                        closure: @escaping () -> Void) {
        self.init()

        GestureTarget.add(gesture: self,
                          closure: closure,
                          toView: targetView)
    }
}

private class GestureTarget: UIView {
    class ClosureContainer {
        weak var gesture: UIGestureRecognizer?
        let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }
    }

    var containers = [ClosureContainer]()

    convenience init() {
        self.init(frame: .zero)
        isHidden = true
    }

    class func add(gesture: UIGestureRecognizer, closure: @escaping () -> Void,
                   toView targetView: UIView) {
        let target: GestureTarget
        if let existingTarget = existingTarget(inTargetView: targetView) {
            target = existingTarget
        } else {
            target = GestureTarget()
            targetView.addSubview(target)
        }
        let container = ClosureContainer(closure: closure)
        container.gesture = gesture
        target.containers.append(container)

        gesture.addTarget(target, action: #selector(GestureTarget.target(gesture:)))
        targetView.addGestureRecognizer(gesture)
    }

    class func existingTarget(inTargetView targetView: UIView) -> GestureTarget? {
        for subview in targetView.subviews {
            if let target = subview as? GestureTarget {
                return target
            }
        }
        return nil
    }

    func cleanUpContainers() {
        containers = containers.filter { $0.gesture != nil }
    }

    @objc func target(gesture: UIGestureRecognizer) {
        cleanUpContainers()

        for container in containers {
            guard let containerGesture = container.gesture else {
                continue
            }

            if gesture === containerGesture {
                container.closure()
            }
        }
    }
}

class CustomTabBar: UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    var bottomPadding: CGFloat?
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            bottomPadding = window?.safeAreaInsets.bottom
        }

        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height + bottomPadding!
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            sizeThatFits.height = height + 20
        }
        return sizeThatFits
    }
}

// Gradient extention
extension UIView {
    func applyGradient(colours: [UIColor]) {
        applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0.0)
        layer.addSublayer(gradient)
    }

    func applyGradientwithRadius(colours: [UIColor]) {
        applyGradientwithRadius(colours: colours, locations: nil)
    }

    func applyGradientwithRadius(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds

        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 20

        layer.addSublayer(gradient)
    }
}

// Gradient button swift

extension UIButton {
    func apptextColor(colours: [UIColor]) -> Any {
        return apptextColor(colours: colours, locations: nil)
    }

    func apptextColor(colours: [UIColor], locations: [NSNumber]?) -> [Any] {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations

        layer.addSublayer(gradient)
        return gradient.colors!
    }
}

// MARK: - Slider

class CustomSlide: UISlider {
    @IBInspectable var trackHeight: CGFloat = 2

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}

// MARK: - Shadow

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat, scale: Bool) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// MARK: - Rotation of View

extension UIView {
    func setTransformRotation(toDegrees angleInDegrees: CGFloat) {
        let angleInRadians = angleInDegrees / 180.0 * CGFloat.pi
        let rotation = transform.rotated(by: angleInRadians)
        transform = rotation
    }
}

// MARK: - Add Bottom Line to textfield

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor

        attributedPlaceholder = NSAttributedString(string: placeholder ?? "-", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
    }
}

// Validation
extension String {
    // To check text field or String is blank or not
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }

    // Validate Email

    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count)) != nil
        } catch {
            return false
        }
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    // validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count)) != nil {
                if count >= 6, count <= 20 {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

// MARK: - View fade in fade out

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.5, completion: @escaping ((Bool) -> Void) = { (_: Bool) -> Void in }) {
        alpha = 0.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 1.5, delay: TimeInterval = 0.5, completion: @escaping (Bool) -> Void = { (_: Bool) -> Void in }) {
        alpha = 1.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { _ in
            self.isHidden = true
            completion(true)
        }
    }
}
