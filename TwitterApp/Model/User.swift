//
//  User.swift
//  TwitterApp
//
//  Created by andy on 20.08.2021.
//

import Foundation

struct User {
    let uid: String
    let email: String
    let fullname: String
    var profileImageUrl: URL?
    let username: String
    var isCurrentUser: Bool { AuthService.shared.currentUserId == uid }
    var isFollowed = false
    var stats: UserRelationStats?

    init(uid: String, dict: [String: Any]) {
        self.uid = uid

        email = dict["email"] as? String ?? ""
        fullname = dict["fullname"] as? String ?? ""
        username = dict["username"] as? String ?? ""

        if
            let profileImageUrlString = dict["profileImageUrl"] as? String,
            let profileImageUrl = URL(string: profileImageUrlString)
        {
            self.profileImageUrl = profileImageUrl
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
