//
//  UI.swift
//  TwitterApp
//
//  Created by andy on 19.08.2021.
//

import UIKit

class UI {
    
    static func inputContainerView(image: UIImage, textField: UITextField) -> UIView {
        let view = UIView().height(50)

        let imageView: UIImageView = {
            let imageView = UIImageView(image: image)

            view.addSubview(imageView)

            imageView
                .left(to: view.leftAnchor)
                .bottom(to: view.bottomAnchor, 8)
                .size(width: 24, height: 24)

            return imageView
        }()

        view.addSubview(textField)
        textField
            .left(to: imageView.rightAnchor, 8)
            .bottom(to: view.bottomAnchor, 8)
            .right(to: view.rightAnchor)

        let dividerView = UIView()

        dividerView.backgroundColor = .white

        view.addSubview(dividerView)

        dividerView
            .left(to: imageView.leftAnchor)
            .bottom(to: view.bottomAnchor)
            .right(to: view.rightAnchor)
            .height(0.75)

        return view
    }

    static func textField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )

        return tf
    }

    static func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])

        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))

        button.setAttributedTitle(attributedTitle, for: .normal)

        return button
    }

    static func submitButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.height(50)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)

        return button
    }

    static func roundImageView(size: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.size(width: size, height: size)
        imageView.layer.cornerRadius = size / 2
//        imageView.backgroundColor = .twitterBlue

        return imageView
    }

    static func actionButton(image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.size(width: 20, height: 20)

        return button
    }
}
