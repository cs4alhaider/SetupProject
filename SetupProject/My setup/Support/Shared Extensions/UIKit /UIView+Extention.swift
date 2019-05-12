//
//  UIView+Extention.swift
//  SetupProject
//
//  Created by Abdullah Alhaider on 05/05/2019.
//  Copyright © 2019 Abdullah Alhaider - https://github.com/cs4alhaider. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Two cases replacing `isHidden`
    ///
    /// - visible: means `isHidden = false`
    /// - hidden: means `isHidden = true`
    ///
    /// - Author: Abdullah Alhaider.
    enum UIViewDisplayMode {
        case visible
        case hidden
        // Please do not add any extra cases
    }
    
    /// Elegent way to show and hide any UIView insted of `someView.isHidden = true` or `!someView.isHidden = true`
    ///
    /// - Author: Abdullah Alhaider.
    var display: UIViewDisplayMode {
        get {
            return self.isHidden ? .hidden : .visible
        }
        set {
            return self.isHidden = newValue == .hidden ? true : false
        }
    }
    
    // ---------------------------- UIViewAnimation -------------------------------- //
    
    /// Multible of cases to animate any UIView
    ///
    /// - Author: Abdullah Alhaider.
    enum UIViewAnimation {
        /// Will change the color and animate if the duration > 0
        case changeColor(to: UIColor, duration: TimeInterval)
        /// Will hide the view and reduce the alpha value to 0 with animation if the duration > 0
        case hideView(duruation: TimeInterval)
        /// Will show the view and increase the alpha value to 1 with animation if the duration > 0
        case showView(duruation: TimeInterval)
    }
    
    /// Implimntation for all cases in `UIViewAnimation`
    ///
    /// - Parameter animation: UIViewAnimation
    ///
    /// - Author: Abdullah Alhaider.
    func animate(_ animation: UIViewAnimation) {
        switch animation {
        case .changeColor(let newColor, let duration):
            UIView.animate(withDuration: duration) {
                self.backgroundColor = newColor
            }
        case .hideView(let duruation):
            UIView.animate(withDuration: duruation) {
                self.alpha = 0
                self.display = .hidden
            }
        case .showView(let duruation):
            UIView.animate(withDuration: duruation) {
                self.display = .visible
                self.alpha = 1
            }
        }
    }
    
    // -------------------------------------------------------------------------- //
    
    /// Adding array of views to the subView
    ///
    /// - Parameter views: UIView | UIButton | UIImageView and all other UIKit elements
    ///
    /// - Author: Abdullah Alhaider.
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    /// Adding round corners to a UIView | UIButton | UIImageView and all other UIKit elements
    ///
    /// - Parameters:
    ///   - corners: .topLeft | .topRight | .bottomLeft | .bottomRight
    ///   - radius: corner radius
    ///
    /// - Author: Abdullah Alhaider
    func roundCorners(corners: UIRectCorner = .allCorners, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            layer.cornerRadius = radius
            guard !corners.contains(.allCorners) else { return }
            layer.maskedCorners = []
            if corners.contains(.topLeft) {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.topRight) {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            }
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    /// Helper method for addSubviewFromNib() to load the nib file into UIView subclass
    ///
    /// - Author: Abdullah Alhaider.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view ?? UIView()
    }
    
    /// Adding the nib file with UIView class
    ///
    /// - Author: Abdullah Alhaider.
    func addSubviewFromNib() {
        let view = viewFromNibForClass()
        view.frame = bounds
        // autolayout
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
