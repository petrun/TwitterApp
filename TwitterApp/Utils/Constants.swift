//
//  Constants.swift
//  TwitterApp
//
//  Created by andy on 19.08.2021.
//

import Firebase

enum APIReference {
    static private let storage = Storage.storage().reference()
    static let profileImages = storage.child("profile_images")

    static private let database = Database.database().reference()
    static let users = database.child("users")

    static let userTweets = database.child("user_tweets")
    static let userFollowers = database.child("user_followers")
    static let userFollowing = database.child("user_following")
    static let userLikes = database.child("user_likes")

    static let tweets = database.child("tweets")
    static let tweetReplies = database.child("tweet_replies")
    static let tweetLikes = database.child("tweet_likes")
}
