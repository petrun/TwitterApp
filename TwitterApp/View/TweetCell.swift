//
//  TweetCell.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import UIKit

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {

    // MARK: - Properties

    var tweet: Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            let viewModel = TweetViewModel(tweet: tweet)

            captionLabel.text = viewModel.caption
            profileImageView.sd_setImage(with: viewModel.profileImageUrl)
            infoLabel.attributedText = viewModel.userInfoText
            likeButton.tintColor = viewModel.likeButtonTintColor
            likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        }
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

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground

        return view
    }()

    private lazy var commentButton: UIButton = {
        let button = UI.actionButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

        return button
    }()

    private lazy var retweetButton: UIButton = {
        let button = UI.actionButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)

        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UI.actionButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)

        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UI.actionButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)

        return button
    }()

    private lazy var infoStack: UIStackView = UI.VStack(
        arrangedSubviews: [infoLabel, captionLabel],
        spacing: 4,
        distribution: .fillProportionally
    )

    private lazy var actionStack = UI.HStack(
        arrangedSubviews:  [
            commentButton,
            retweetButton,
            likeButton,
            shareButton
        ],
        spacing: 0,
        distribution: .equalSpacing
    )

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView) {
            $0.top = 12
            $0.left = 8
        }

        addSubview(infoStack) {
            $0.topAnchor = profileImageView.topAnchor
            $0.leftAnchor = profileImageView.rightAnchor + 12
            $0.right = 12
        }

        addSubview(actionStack) {
            $0.left = 50
            $0.right = 50
            $0.bottom = 8
        }

        addSubview(underlineView) {
            $0.left = 0
            $0.right = 0
            $0.bottom = 0
            $0.height = 1
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    //@todo move to TweetActionsStackView
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }

    @objc func handleRetweetTapped() {
        print("Tap button \(#function)")
    }

    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }

    @objc func handleShareTapped() {
        print("Tap button \(#function)")
    }

    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
}
