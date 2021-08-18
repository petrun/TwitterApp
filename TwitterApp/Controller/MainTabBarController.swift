//
//  MainTabBarController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        confitureViewControllers()
        configureUI()
    }

    // MARK: - Selectors

    @objc func actionButtonTapped() {
        print("ok1")
    }

    // MARK: - Helpers

    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(
            .height(56),
            .width(56),
            .bottom(tabBar.topAnchor, 16),
            .right(view.rightAnchor, 16)
        )
        actionButton.layer.cornerRadius = 28
    }

    private func confitureViewControllers() {
        viewControllers = [
            createNavigationController(image: UIImage(named: "home_unselected"), root: FeedController()),
            createNavigationController(image: UIImage(named: "search_unselected"), root: ExploreController()),
            createNavigationController(image: UIImage(named: "search_unselected"), root: NotificationsController()),
            createNavigationController(image: UIImage(named: "search_unselected"), root: ConversationsController())
        ]
    }

    private func createNavigationController(image: UIImage?, root: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: root)
        nc.tabBarItem.image = image
        nc.navigationBar.barTintColor = .white
        return nc
    }

}
