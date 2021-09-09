//
//  ActionSheetCell.swift
//  TwitterApp
//
//  Created by andy on 08.09.2021.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    // MARK: - Properties

    var option: ActionSheetOptions? {
        didSet{
            titleLabel.text = option?.description
        }
    }

    private let optionImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true

        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(optionImageView) {
            $0.centerY = self
            $0.left = 8
            $0.height = 36
            $0.width = 36
        }

        addSubview(titleLabel) {
            $0.centerY = self
            $0.leftAnchor = optionImageView.rightAnchor + 12
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
