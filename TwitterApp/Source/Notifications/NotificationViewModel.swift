//
// Created by andy on 12.09.2021.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User

    private var notificationMessage: String {
        switch type {
        case .follow: return "started following you"
        case .like: return "liked your tweet"
        case .reply: return "replied to your tweet"
        case .retweet: return "retweeted your tweet"
        case .mention: return "mentioned you in a tweet"
        }
    }

    private var timestamp: String {
        // @todo move to extensions
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]

        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: notification.timestamp, to: Date()) ?? ""
    }

    var notificationText: NSAttributedString? {
        let attributedText = NSMutableAttributedString(string: user.username, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)
        ])

        attributedText.append(NSAttributedString(string: " \(notificationMessage)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]))

        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]))

        return attributedText
    }

    var profileImageUrl: URL? {
        user.profileImageUrl
    }

    var shouldHideFollowButton: Bool {
        type != .follow
    }

    var followButtonText: String {
        user.isFollowed ? "Following" : "Follow"
    }

    init(notification: Notification) {
        self.notification = notification
        type = notification.type
        user = notification.user
    }
}
