//
//  TweetService.swift
//  TwitterApp
//
//  Created by andy on 21.08.2021.
//

import Firebase

struct TweetService {
    static let shared = TweetService()

    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_TWEETS.childByAutoId().updateChildValues([
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "caption": caption,
            "likes": 0,
            "retweets": 0,
        ], withCompletionBlock: completion)
    }
}