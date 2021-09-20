//
//  UserCell.swift
//  TwitterApp
//
//  Created by andy on 02.09.2021.
//

import UIKit

final class UserCell: UITableViewCell {
    // MARK: - Properties

    var user: User? {
        didSet {
            guard let user = user else { return }

            profileImageView.sd_setImage(with: user.profileImageUrl)
            usernameLabel.text = user.username
            fullnameLabel.text = user.fullname
        }
    }

    private let profileImageView: UIImageView = UI.roundImageView(size: 40)

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0

        return label
    }()

    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)

        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)

        let stack = UI.VStack(
            arrangedSubviews: [
                usernameLabel,
                fullnameLabel
            ],
            spacing: 2,
            distribution: .fill
        )

        addSubview(stack)
        stack.centerY(
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 12
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
