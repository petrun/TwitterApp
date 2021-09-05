//
//  CaptionTextView.swift
//  TwitterApp
//
//  Created by andy on 21.08.2021.
//

import UIKit

class CaptionTextView: UITextView {

    // MARK: - Properties

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"

        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        font = .systemFont(ofSize: 16)
        isScrollEnabled = true
        height(300)

        addSubview(placeholderLabel)
        placeholderLabel
            .top(to: topAnchor, 8)
            .left(to: leftAnchor, 4)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextInputChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

}
