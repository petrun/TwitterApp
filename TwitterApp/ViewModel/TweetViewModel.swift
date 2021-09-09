//
//  TweetViewModel.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import UIKit

struct TweetViewModel {
    private let tweet: Tweet
    private let user: User

    private var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]

        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: tweet.timestamp, to: Date()) ?? ""
    }

    var caption: String {
        tweet.caption
    }

    var createdDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm ・ dd/MM/yyyy"

        return formatter.string(from: tweet.timestamp)
    }

    var retweetsString: NSAttributedString? {
        attributedText(value: tweet.retweetCount, text: "Retweets")
    }

    var likesString: NSAttributedString? {
        attributedText(value: tweet.likes, text: "Likes")
    }

    // MARK: - User Info

    var profileImageUrl: URL? {
        user.profileImageUrl
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

    var userFullname: String {
        user.fullname
    }

    var usernameText: String {
        "@\(user.username)"
    }

    init(tweet: Tweet) {
        self.tweet = tweet
        user = tweet.user
    }

    // MARK: - Helpers

    func height(forWidth width: CGFloat) ->CGFloat {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.width(width)

        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }

    private func attributedText(value: Int, text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(value) ", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
        ])

        attributedString.append(NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
        ]))

        return attributedString
    }
}
