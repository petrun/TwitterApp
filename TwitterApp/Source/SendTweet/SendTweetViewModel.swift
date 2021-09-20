//
//  SendTweetViewModel.swift
//  TwitterApp
//
//  Created by andy on 05.09.2021.
//

import UIKit

enum TweetType {
    case tweet
    case reply(Tweet)
}

struct SendTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    let isShowReplyLabel: Bool
    var replyText: String?

    init(type: TweetType) {
        switch type {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening"
            isShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            isShowReplyLabel = true
            replyText = "Reply to @\(tweet.user.username)"
        }
    }
}
