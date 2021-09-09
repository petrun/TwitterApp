//
//  Extensions.swift
//  TwitterApp
//
//  Created by andy on 18.08.2021.
//

import UIKit

extension UIView {
    @discardableResult
    func top(to anchor: NSLayoutYAxisAnchor, _ paddingTop: CGFloat = 0) -> Self {
        activateConstraints(topAnchor.constraint(equalTo: anchor, constant: paddingTop))
    }

    @discardableResult
    func left(to anchor: NSLayoutXAxisAnchor, _ paddingLeft: CGFloat = 0) -> Self {
        activateConstraints(leftAnchor.constraint(equalTo: anchor, constant: paddingLeft))
    }

    @discardableResult
    func bottom(to anchor: NSLayoutYAxisAnchor, _ paddingBottom: CGFloat = 0) -> Self {
        activateConstraints(bottomAnchor.constraint(equalTo: anchor, constant: -paddingBottom))
    }

    @discardableResult
    func right(to anchor: NSLayoutXAxisAnchor, _ paddingRight: CGFloat = 0) -> Self {
        activateConstraints(rightAnchor.constraint(equalTo: anchor, constant: -paddingRight))
    }

    @discardableResult
    func width(_ width: CGFloat) -> Self {
        activateConstraints(widthAnchor.constraint(equalToConstant: width))
    }

    @discardableResult
    func height(_ height: CGFloat) -> Self {
        activateConstraints(heightAnchor.constraint(equalToConstant: height))
    }

    @discardableResult
    func size(width: CGFloat, height: CGFloat) -> Self {
        activateConstraints(
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        )
    }

    @discardableResult
    func fill(view: UIView) -> Self {
        activateConstraints(
            topAnchor.constraint(equalTo: view.topAnchor),
            leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor)
        )
    }

    @discardableResult
    func center(inView view: UIView, yConstant: CGFloat = 0) -> Self {
        activateConstraints(
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant)
        )
    }

    @discardableResult
    func centerX(
        in view: UIView,
        topAnchor: NSLayoutYAxisAnchor? = nil,
        paddingTop: CGFloat = 0
    ) -> Self {
        var constraints: [NSLayoutConstraint] = [
            centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        if let topAnchor = topAnchor {
            constraints.append(
                self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop)
            )
        }

        return activateConstraints(constraints)
    }

    @discardableResult
    func centerY(
        inView view: UIView,
        constant: CGFloat = 0,
        leftAnchor: NSLayoutXAxisAnchor? = nil,
        paddingLeft: CGFloat = 0
    ) -> Self {
        var constraints: [NSLayoutConstraint] = [
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
        ]

        if let leftAnchor = leftAnchor {
            constraints.append(
                self.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingLeft)
            )
        }

        return activateConstraints(constraints)
    }

    @discardableResult
    private func activateConstraints(_ constraints: NSLayoutConstraint...) -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraints)

        return self
    }

    @discardableResult
    private func activateConstraints(_ constraints: [NSLayoutConstraint]) -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraints)

        return self
    }
}

extension UIView {
    @discardableResult
    func border(_ color: UIColor, width: CGFloat) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width

        return self
    }
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }

    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
}

// MARK: - UIApplication

extension UIApplication {
    func getRootViewController() -> UIViewController? {
        windows.first { $0.isKeyWindow }?.rootViewController
    }
}
