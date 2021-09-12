//
// Created by andy on 11.09.2021.
//

import Foundation

struct NotificationService {
    static let shared = NotificationService()

    private init() {}

    func sendNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let uid = AuthService.shared.currentUserId else { return }

        var values: [String: Any] = [
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "uid": uid,
            "type": type.rawValue
        ]

        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID

            APIReference.notifications.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            APIReference.notifications.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }

    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let uid = AuthService.shared.currentUserId else { return }

        var notifications: [Notification] = []

        APIReference.notifications.child(uid).observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                notifications.append(Notification(user: user, dict: dict))
                completion(notifications)
            }
        }
    }
}
