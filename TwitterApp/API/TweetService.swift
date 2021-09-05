//
//  TweetService.swift
//  TwitterApp
//
//  Created by andy on 21.08.2021.
//

import Firebase

struct TweetService {
    static let shared = TweetService()

    private init() {}

    func createTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref = REF_TWEETS.childByAutoId()

        ref.updateChildValues([
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "caption": caption,
            "likes": 0,
            "retweets": 0,
        ]) { (error, ref) in
            if let error = error {
                completion(error, ref)
                return;
            }
            guard let tweetId = ref.key else { return }

            REF_USER_TWEETS.child(uid).updateChildValues([
                tweetId: 1,
            ], withCompletionBlock: completion)
        }
    }

    func reply(to tweet: Tweet, caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues([
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "caption": caption,
            "likes": 0,
            "retweets": 0,
        ], withCompletionBlock: completion)
    }

    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()

        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            }
        }
    }

    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()

        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            REF_TWEETS.child(tweetId).observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }

                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            })
        }
    }

    func fetchReplies(for tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()

        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            }
        }
    }
}
