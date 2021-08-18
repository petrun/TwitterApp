//
//  Extensions.swift
//  TwitterApp
//
//  Created by andy on 18.08.2021.
//

import UIKit

extension UIView {
    enum Size {
        case top(NSLayoutYAxisAnchor, CGFloat = 0)
        case left(NSLayoutXAxisAnchor, CGFloat = 0)
        case bottom(NSLayoutYAxisAnchor, CGFloat = 0)
        case right(NSLayoutXAxisAnchor, CGFloat = 0)
        case width(CGFloat)
        case height(CGFloat)
    }

    func anchor(_ sizes: Size...) {
        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        for size in sizes {
            switch size {
            case .top(let top, let paddingTop):
                constraints.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
            case .left(let left, let paddingLeft):
                constraints.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
            case .bottom(let bottom, let paddingBottom):
                constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
            case .right(let right, let paddingRight):
                constraints.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
            case .width(let width):
                constraints.append(widthAnchor.constraint(equalToConstant: width))
            case .height(let height):
                constraints.append(heightAnchor.constraint(equalToConstant: height))
            }
        }

        NSLayoutConstraint.activate(constraints)
    }

    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }

    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false

        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true

        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }

    func setDimensions(width: CGFloat, height: CGFloat) {
        anchor(.width(width), .height(height))

//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalToConstant: width).isActive = true
//        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func addConstraintsToFillView(_ view: UIView) {
        anchor(
            .top(view.topAnchor),
            .left(view.leftAnchor),
            .bottom(view.bottomAnchor),
            .right(view.rightAnchor)
        )
//        translatesAutoresizingMaskIntoConstraints = false
//        anchor(top: view.topAnchor, left: view.leftAnchor,
//               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }

    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
}
