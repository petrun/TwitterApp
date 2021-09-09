//
//  ProfileHeader.swift
//  TwitterApp
//
//  Created by andy on 26.08.2021.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleDismissal()
    func handleEditProfile(_ header: ProfileHeader)
    func handleFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties

    weak var delegate: ProfileHeaderDelegate?

    var user: User? {
        didSet {
            guard let user = user else { return }

            let profileHeaderViewModel = ProfileHeaderViewModel(user: user)
            followingLabel.attributedText = profileHeaderViewModel.followingString
            followersLabel.attributedText = profileHeaderViewModel.followersString

            profileImageView.sd_setImage(with: user.profileImageUrl)

            editProfileFollowButton.setTitle(
                profileHeaderViewModel.actionButtonTitle,
                for: .normal
            )

            if user.isCurrentUser {
                editProfileFollowButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
            } else {
                editProfileFollowButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
            }

            fullnameLabel.text = profileHeaderViewModel.fullnameText
            usernameLabel.text = profileHeaderViewModel.usernameText
        }
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton
            .top(to: view.topAnchor, 42)
            .left(to: view.leftAnchor, 16)
            .size(width: 30, height: 30)

        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)

        return button
    }()

    private let profileImageView: UIImageView = {
        let imageView = UI.roundImageView(size: 80)
        imageView.border(.white, width: 4)

        return imageView
    }()

    lazy var editProfileFollowButton: UIButton = {
        let height: CGFloat = 36
        let button = UIButton(type: .system)
        button
            .border(.twitterBlue, width: 1.25)
            .size(width: 100, height: height)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = height / 2

        return button
    }()

    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)

        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray

        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = """
This is a user bio what will span more than one line for test
purposes This is a user bio what will span more than one line for test purposes
This is a user bio what will span more than one line for test purposes
"""
        return label
    }()

    private let filterBar = ProfileFilterView()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue

        return view
    }()

    private let followingLabel: UILabel = {
        let label = UILabel()

        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        )

        return label
    }()

    private let followersLabel: UILabel = {
        let label = UILabel()

        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        )

        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        filterBar.delegate = self

        [
            containerView,
            profileImageView,
            editProfileFollowButton,
            filterBar,
            underlineView
        ].forEach { addSubview($0) }

        containerView
            .top(to: topAnchor)
            .left(to: leftAnchor)
            .right(to: rightAnchor)
            .height(110)

        profileImageView
            .top(to: containerView.bottomAnchor, -25)
            .left(to: leftAnchor, 8)

        editProfileFollowButton
            .top(to: containerView.bottomAnchor, 12)
            .right(to: rightAnchor, 12)

        let userDetailsStack: UIStackView = {
            let userDetailsStack = UI.VStack(
                arrangedSubviews: [
                    fullnameLabel,
                    usernameLabel,
                    bioLabel
                ],
                spacing: 4,
                distribution: .fillProportionally
            )

            addSubview(userDetailsStack)
            userDetailsStack
                .top(to: profileImageView.bottomAnchor, 8)
                .left(to: leftAnchor, 12)
                .right(to: rightAnchor, 12)

            return userDetailsStack
        }()

        let followStack = UI.HStack(
            arrangedSubviews: [followingLabel, followersLabel],
            spacing: 8,
            distribution: .fillEqually
        )

        addSubview(followStack)
        followStack
            .top(to: userDetailsStack.bottomAnchor, 8)
            .left(to: leftAnchor, 12)

        filterBar
            .left(to: leftAnchor)
            .right(to: rightAnchor)
            .bottom(to: bottomAnchor)
            .height(50)

        underlineView
            .left(to: leftAnchor)
            .bottom(to: bottomAnchor)
            .width(frame.width / CGFloat(filterBar.options.count))
            .height(2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleBackButton() {
        delegate?.handleDismissal()
    }

    @objc func handleEditProfile() {
        delegate?.handleEditProfile(self)
    }

    @objc func handleFollow() {
        delegate?.handleFollow(self)
    }

    @objc func handleFollowersTapped() {
        print("Call handleFollowersTapped")
    }

    @objc func handleFollowingTapped() {
        print("Call handleFollowingTapped")
    }
}

// MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }

        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
