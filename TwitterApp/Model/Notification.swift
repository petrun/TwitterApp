//
// Created by andy on 11.09.2021.
//

import Foundation

// @todo use factory
enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var type: NotificationType!
// @todo var message
// @todo var action

    init(user: User, dict: [String: Any]) {
        if let tweetID = dict["tweetID"] as? String {
            self.tweetID = tweetID
        }

        if let type = dict["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }

        if let timestamp = dict["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }

        self.user = user
    }
}
