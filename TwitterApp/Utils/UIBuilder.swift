//
//  UIBuilder.swift
//  TwitterApp
//
//  Created by andy on 04.09.2021.
//

import UIKit

class Constraints {
    var width: CGFloat?
    var height: CGFloat?

    var top: CGFloat?
    var bottom: CGFloat?
    var left: CGFloat?
    var right: CGFloat?

    var topAnchor: NSLayoutYAxisAnchor?
    var bottomAnchor: NSLayoutYAxisAnchor?
    var leftAnchor: NSLayoutXAxisAnchor?
    var rightAnchor: NSLayoutXAxisAnchor?

    var centerY: UIView?
    var centerX: UIView?
}

private class ConstantsCache {
    var cache: [Int: CGFloat] = [:]

    static var shared = ConstantsCache()

    private init() {}

    func add(_ hash: Int, value: CGFloat) {
        cache[hash] = value
    }

    func get(_ hash: Int) -> CGFloat {
        cache[hash] ?? 0
    }
}

extension UIView {
    func addSubview(_ view: UIView, completion: (Constraints) -> Void) {
        self.addSubview(view)

        let constraints = Constraints()
        completion(constraints)

        if let height = constraints.height {
            view.height(height)
        }

        if let width = constraints.width {
            view.width(width)
        }

        if let top = constraints.top {
            view.top(to: topAnchor, top)
        }

        if let bottom = constraints.bottom {
            view.bottom(to: bottomAnchor, bottom)
        }

        if let left = constraints.left {
            view.left(to: leftAnchor, left)
        }

        if let right = constraints.right {
            view.right(to: rightAnchor, right)
        }

        if let topAnchor = constraints.topAnchor {
            view.top(to: topAnchor, ConstantsCache.shared.get(topAnchor.hash) )
        }

        if let bottomAnchor = constraints.bottomAnchor {
            view.bottom(to: bottomAnchor, ConstantsCache.shared.get(bottomAnchor.hash) )
        }

        if let leftAnchor = constraints.leftAnchor {
            view.left(to: leftAnchor, ConstantsCache.shared.get(leftAnchor.hash) )
        }

        if let rightAnchor = constraints.rightAnchor {
            view.right(to: rightAnchor, ConstantsCache.shared.get(rightAnchor.hash) )
        }

        if let centerY = constraints.centerY {
            view.centerY(inView: centerY)
        }

        if let centerX = constraints.centerX {
            view.centerX(in: centerX)
        }
    }
}

extension NSLayoutXAxisAnchor {
    static func + (lhs: NSLayoutXAxisAnchor, rhs: CGFloat) -> NSLayoutXAxisAnchor {
        ConstantsCache.shared.add(lhs.hash, value: rhs)
        return lhs
    }
}

extension NSLayoutYAxisAnchor {
    static func + (lhs: NSLayoutYAxisAnchor, rhs: CGFloat) -> NSLayoutYAxisAnchor {
        ConstantsCache.shared.add(lhs.hash, value: rhs)
        return lhs
    }
}
