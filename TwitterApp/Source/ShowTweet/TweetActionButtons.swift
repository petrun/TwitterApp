//
//  TweetActions.swift
//  TwitterApp
//
//  Created by andy on 04.09.2021.
//

import UIKit

final class TweetActionButtons: UIStackView {
    // MARK: - likeButton

    lazy var isLiked = false {
        didSet {
            likeButton.setImage(likeButtonImage, for: .normal)
            likeButton.tintColor = likeButtonTintColor
        }
    }

    private var likeButtonImage: UIImage? {
        UIImage(named: isLiked ? "like_filled" : "like")
    }

    private var likeButtonTintColor: UIColor {
        isLiked ? .red : .lightGray
    }

    private lazy var likeButton: UIButton = {
        let button = UI.actionButton(image: likeButtonImage, tintColor: likeButtonTintColor)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - commentButton

    private lazy var commentButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "comment"))
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - retweetButton

    private lazy var retweetButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "retweet"))
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - shareButton

    private lazy var shareButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "share"))
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        [
            commentButton,
            retweetButton,
            likeButton,
            shareButton
        ].forEach { addArrangedSubview($0) }

        spacing = 78
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleCommentTapped() {
        print("Tap button \(#function)")
    }

    @objc func handleRetweetTapped() {
        print("Tap button \(#function)")
    }

    @objc func handleLikeTapped() {
        print("Tap button \(#function)")
    }

    @objc func handleShareTapped() {
        print("Tap button \(#function)")
    }
}
