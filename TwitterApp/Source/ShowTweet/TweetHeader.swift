//
//  TweetHeader.swift
//  TwitterApp
//
//  Created by andy on 03.09.2021.
//

import UIKit

protocol TweetHeaderDelegate: class {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    // MARK: - Properties

    var tweet: Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            let viewModel = TweetViewModel(tweet: tweet)

            captionLabel.text = viewModel.caption
            profileImageView.sd_setImage(with: viewModel.profileImageUrl)
            fullnameLabel.text = viewModel.userFullname
            usernameLabel.text = viewModel.usernameText
            dateLabel.text = viewModel.createdDateTime

            retweetLabel.attributedText = viewModel.retweetsString
            likesLabel.attributedText = viewModel.likesString

            actionButtons.isLiked = tweet.isLiked

            replyLabel.isHidden = viewModel.shouldHideReplyLabel
            replyLabel.text = viewModel.replyText
        }
    }

    weak var delegate: TweetHeaderDelegate?

    private lazy var profileImageView: UIImageView = {
        let imageView = UI.roundImageView(size: 48)
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        )
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)

        return label
    }()

    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)

        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray

        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0

        return label
    }()

    private let retweetLabel = UILabel()

    private let likesLabel = UILabel()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left

        return label
    }()

    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)

        return button
    }()

    private lazy var usernameStack = UI.VStack(
        arrangedSubviews: [
            fullnameLabel,
            usernameLabel
        ],
        spacing: -6
    )

    private lazy var userInfoStack = UI.HStack(
        arrangedSubviews: [
            profileImageView,
            usernameStack
        ],
        spacing: 12
    )

    private lazy var statsView: UIView = {
        func createDivider() -> UIView {
            let view = UIView()
            view.backgroundColor = .systemGroupedBackground
            view.height(1)

            return view
        }

        let view = UIView()

        let stack = UI.HStack(
            arrangedSubviews: [
                retweetLabel,
                likesLabel
            ],
            spacing: 12
        )

        view.addSubview(createDivider()) {
            $0.top = 0
            $0.left = 8
            $0.right = 8
        }

        view.addSubview(stack) {
            $0.centerY = view
            $0.left = 16
        }

        view.addSubview(createDivider()) {
            $0.bottom = 0
            $0.left = 8
            $0.right = 8
        }

        return view
    }()

    private lazy var mainStack = UI.VStack(
        arrangedSubviews: [
            replyLabel,
            userInfoStack
        ],
        spacing: 8,
        distribution: .fillProportionally,
        alignment: .leading
    )

    private let actionButtons = TweetActionButtons()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(mainStack) {
            $0.top = 16
            $0.left = 16
        }

        addSubview(captionLabel) {
            $0.topAnchor = mainStack.bottomAnchor + 20
            $0.left = 16
            $0.right = 16
        }

        addSubview(dateLabel) {
            $0.topAnchor = captionLabel.bottomAnchor + 20
            $0.left = 16
        }

        addSubview(optionsButton) {
            $0.centerY = userInfoStack
            $0.right = 8
        }

        addSubview(statsView) {
            $0.topAnchor = dateLabel.bottomAnchor + 20
            $0.left = 0
            $0.right = 0
            $0.height = 40
        }

        addSubview(actionButtons) {
            $0.topAnchor = statsView.bottomAnchor
            $0.centerX = self
            $0.bottomAnchor = bottomAnchor + 8
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleProfileImageTapped() {
        print("Call handleProfileImageTapped")
    }

    @objc func showActionSheet() {
        delegate?.showActionSheet()
    }
}
