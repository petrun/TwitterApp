//
//  Tweet.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let timestamp: Date
    var likes: Int
    let retweetCount: Int
    let user: User
    var isLiked = false

    init(user: User, tweetID: String, dict: [String: Any]) {
        self.user = user
        self.tweetID = tweetID

        caption = dict["caption"] as? String ?? ""
        likes = dict["likes"] as? Int ?? 0
        retweetCount = dict["retweets"] as? Int ?? 0

        if let timestamp = dict["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            timestamp = Date()
        }
    }
}
