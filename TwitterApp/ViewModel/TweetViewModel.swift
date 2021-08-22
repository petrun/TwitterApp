//
//  TweetViewModel.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User

    var profileImageUrl: URL? {
        user.profileImageUrl
    }

    private var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]

        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: tweet.timestamp, to: Date()) ?? ""
    }

    var userInfoText: NSAttributedString {
        let text = NSMutableAttributedString(string: user.fullname, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
        ])

        text.append(NSAttributedString(string: " @\(user.username) ・ \(timestamp)", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
        ]))

        return text
    }

    var caption: String {
        tweet.caption
    }

    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}
