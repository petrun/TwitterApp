//
//  TweetCell.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import UIKit

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {

    // MARK: - Properties

    var tweet: Tweet? {
        didSet { configure() }
    }

    weak var delegate: TweetCellDelegate?

    private lazy var profileImageView: UIImageView = {
        let imageView = UI.roundImageView(size: 48)
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        )
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0

        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private lazy var commentButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "comment"))
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

        return button
    }()

    private lazy var retweetButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "retweet"))
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)

        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "like"))
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)

        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UI.actionButton(image: UIImage(named: "share"))
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)

        profileImageView
            .top(to: topAnchor, 12)
            .left(to: leftAnchor, 8)

        let stack = UI.VStack(
            arrangedSubviews: [infoLabel, captionLabel],
            spacing: 4,
            distribution: .fillProportionally
        )

        addSubview(stack)

        stack
            .top(to: profileImageView.topAnchor)
            .left(to: profileImageView.rightAnchor, 12)
            .right(to: rightAnchor, 12)

        let actionStack = UI.HStack(
            arrangedSubviews:  [
                commentButton,
                retweetButton,
                likeButton,
                shareButton
            ],
            spacing: 0,
            distribution: .equalSpacing
        )

        addSubview(actionStack)

        actionStack
            .left(to: leftAnchor, 50)
            .right(to: rightAnchor, 50)
            .bottom(to: bottomAnchor, 8)

        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)

        underlineView
            .left(to: leftAnchor)
            .right(to: rightAnchor)
            .bottom(to: bottomAnchor)
            .height(1)
    }

    required init?(coder: NSCoder) {
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

    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }

    // MARK: - Helpers

    private func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = viewModel.caption
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
    }
}
