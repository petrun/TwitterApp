//
//  NotificationsController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

final class NotificationsController: UITableViewController {
    // MARK: - Properties

    private var notifications: [Notification] = [] {
        didSet { tableView.reloadData() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    // MARK: - Selectors

    @objc func handleRefresh() {
        fetchNotifications()
    }

    // MARK: - API

    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications {
            self.refreshControl?.endRefreshing()

            self.notifications = $0

            self.notifications.forEach { notification in
                guard notification.type == .follow else { return }

                UserService.shared.checkIfUserIsFollowed(uid: notification.user.uid) {
                    guard let index = self.notifications.firstIndex(where: {
                        $0.type == notification.type && $0.user.uid == notification.user.uid
                    }) else { return }
                    self.notifications[index].user.isFollowed = $0
                }
            }
        }
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"

        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none

        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

// MARK: - UITableViewDataSource

extension NotificationsController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! NotificationCell

        cell.delegate = self
        cell.notification = notifications[indexPath.row]
        cell.isUserInteractionEnabled = true

        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationsController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }

        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            self.navigationController?.pushViewController(TweetController(tweet: tweet), animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func handleProfileImageTapped(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }

        navigationController?.pushViewController(
            ViewControllerFactory.shared.makeProfileViewController(user: user),
            animated: true
        )
    }

    func handleFollowTapped(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }

        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, _ in
                if let error = error {
                    print("DEBUG: Unfollow user error \(error.localizedDescription)")
                    return
                }

                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, _ in
                if let error = error {
                    print("DEBUG: Unfollow user error \(error.localizedDescription)")
                    return
                }

                cell.notification?.user.isFollowed = true
            }
        }
    }
}
