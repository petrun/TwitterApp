//
//  ProfileHeaderViewModel.swift
//  TwitterApp
//
//  Created by andy on 01.09.2021.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets, replies, likes

    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User

    let usernameText: String
    var fullnameText: String {
        user.fullname
    }

    var followersString: NSAttributedString {
        attributedText(value: user.stats?.followers ?? 0, text: "followers")
    }

    var followingString: NSAttributedString {
        attributedText(value: user.stats?.following ?? 0, text: "following")
    }

    var actionButtonTitle: String {
        user.isCurrentUser ? "Edit profile" :
            (user.isFollowed ? "Following" : "Follow")
    }

    init(user: User) {
        self.user = user

        usernameText = "@\(user.username)"
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
