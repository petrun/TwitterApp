//
//  MainTabBarController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import Firebase
import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    var user: User? {
        didSet {
            guard let nav = viewControllers?.first as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }

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

//        logout()
        authUserAndConfigureUI()
    }

    // MARK: - API

    func authUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }

            print("DEBUG: User is NOT logged in")
        } else {
            confitureViewControllers()
            configureUI()
            fetchUser()

            print("DEBUG: User is logged in")
        }
    }

    private func fetchUser() {
        UserService.shared.fetchUser { self.user = $0 }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    // MARK: - Selectors

    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: SendTweetController(user: user))
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }

    // MARK: - Helpers

    private func configureUI() {
        view.addSubview(actionButton)
        actionButton
            .size(width: 56, height: 56)
            .bottom(to: tabBar.topAnchor, 16)
            .right(to: view.rightAnchor, 16)

        actionButton.layer.cornerRadius = 28
    }

    private func confitureViewControllers() {
        viewControllers = [
            createNavigationController(image: UIImage(named: "home_unselected"), root: FeedController()),
            createNavigationController(image: UIImage(named: "search_unselected"), root: ExploreController()),
            createNavigationController(image: UIImage(named: "like_unselected"), root: NotificationsController()),
            createNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), root: ConversationsController())
        ]
    }

    private func createNavigationController(image: UIImage?, root: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: root)
        nc.tabBarItem.image = image
        nc.navigationBar.barTintColor = .white
        return nc
    }

}
