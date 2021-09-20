//
// Created by andy on 11.09.2021.
//

import UIKit

protocol NotificationCellDelegate: class {
    func handleProfileImageTapped(_ cell: NotificationCell)
    func handleFollowTapped(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    // MARK: - Properties

    weak var delegate: NotificationCellDelegate?

    var notification: Notification? {
        didSet {
            guard let notification = notification else { return }
            let viewModel = NotificationViewModel(notification: notification)

            profileImageView.sd_setImage(with: viewModel.profileImageUrl)
            notificationLabel.attributedText = viewModel.notificationText
            followButton.setTitle(viewModel.followButtonText, for: .normal)
            followButton.isHidden = viewModel.shouldHideFollowButton
        }
    }

    private lazy var profileImageView: UIImageView = {
        let imageView = UI.roundImageView(size: 40)
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        )
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private lazy var followButton: UIButton = {
        let height: CGFloat = 32
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.size(width: 92, height: height)
        button.layer.cornerRadius = height / 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)

        return button
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    // MARK: - Lifecycle

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(
            UI.HStack(
                arrangedSubviews: [ profileImageView, notificationLabel],
                spacing: 8,
                alignment: .center
            )
        ) {
            $0.centerY = self
            $0.left = 12
            $0.right = 12
        }

        contentView.addSubview(followButton) {
            $0.centerY = self
            $0.right = 12
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleProfileImageTapped() {
        print("Click handleProfileImageTapped")
        delegate?.handleProfileImageTapped(self)
    }

    @objc func handleFollowTapped() {
        print("Click handleFollowTapped")
        delegate?.handleFollowTapped(self)
    }
}
