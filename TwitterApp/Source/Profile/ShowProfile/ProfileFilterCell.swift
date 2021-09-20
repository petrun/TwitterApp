//
//  ProfileFilterCell.swift
//  TwitterApp
//
//  Created by andy on 27.08.2021.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // MARK: - Properties

    let titleLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            switchSelected(isSelected: isSelected)
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.center(inView: self)
        switchSelected(isSelected: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    // MARK: - Helpers

    private func switchSelected(isSelected: Bool) {
        titleLabel.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 14)
        titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
    }
}
