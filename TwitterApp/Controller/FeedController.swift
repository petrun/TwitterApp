//
//  FeedController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import SDWebImage
import UIKit

final class FeedController: UIViewController {
    // MARK: - Properties

    var user: User? {
        didSet { configureLeftBarButton() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white

        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.size(width: 44, height: 44)
        navigationItem.titleView = imageView
    }

    private func configureLeftBarButton() {
        guard let user = user else { return }

        let profileImageView = UI.roundImageView(size: 32)
        profileImageView.sd_setImage(with: user.profileImageUrl)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
