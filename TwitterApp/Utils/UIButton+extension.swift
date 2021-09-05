//
//  UIButton+extension.swift
//  TwitterApp
//
//  Created by andy on 04.09.2021.
//

import UIKit

extension UIButton {
    convenience init(withImageName imageName: String) {
        self.init(type: .system)
        setImage(UIImage(named: imageName), for: .normal)
    }
}
