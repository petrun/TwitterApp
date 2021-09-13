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

        let ref = APIReference.tweets.childByAutoId()

        ref.updateChildValues(
            [
                "uid": uid,
                "timestamp": Int(NSDate().timeIntervalSince1970),
                "caption": caption,
                "likes": 0,
                "retweets": 0
            ]
        ) { error, ref in
            if let error = error {
                completion(error, ref)
                return
            }
            guard let tweetId = ref.key else { return }

            APIReference.userTweets.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
        }
    }

    func reply(to tweet: Tweet, caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let tweetId = tweet.tweetID

        APIReference.tweetReplies.child(tweetId).childByAutoId().updateChildValues(
            [
                "uid": uid,
                "timestamp": Int(NSDate().timeIntervalSince1970),
                "caption": caption,
                "likes": 0,
                "retweets": 0,
                "replyingTo": tweet.user.username
            ]
        ) { error, ref in
            if let error = error {
                completion(error, ref)
                return
            }
            guard let replyId = ref.key else { return }

            APIReference.userReplies.child(uid).updateChildValues([tweetId: replyId], withCompletionBlock: completion)
        }
    }

    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        APIReference.tweets.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                completion(Tweet(user: user, tweetID: tweetID, dict: dict))
            }
        }
    }

    func fetchFollowingTweets(completion: @escaping([Tweet]) -> Void) {
        guard let uid = AuthService.shared.currentUserId else { return }

        var tweets: [Tweet] = []

        APIReference.userFollowing.child(uid).observe(.childAdded) { snapshot in
            APIReference.userTweets.child(snapshot.key).observe(.childAdded) { snapshot in
                self.fetchTweet(withTweetID: snapshot.key) {
                    tweets.append($0)
                    completion(tweets)
                }
            }
        }

        APIReference.tweets.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            }
        }
    }

    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []

        APIReference.tweets.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            }
        }
    }

    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []

        APIReference.userTweets.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key

            APIReference.tweets.child(tweetId).observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }

                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            }
        }
    }

    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies: [Tweet] = []

        APIReference.userReplies.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            guard let replyId = snapshot.value as? String else { return }

            APIReference.tweetReplies.child(tweetId).child(replyId).observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }

                replies.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(replies)
            }
        }
    }

    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []

        APIReference.tweetReplies.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                tweets.append(Tweet(user: user, tweetID: snapshot.key, dict: dict))
                completion(tweets)
            }
        }
    }

    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []

        APIReference.userLikes.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key

            self.fetchTweet(withTweetID: tweetId) {
                var tweet = $0
                tweet.isLiked = true

                tweets.append(tweet)
                completion(tweets)
            }
        }
    }

    func like(tweet: Tweet, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let tweetID = tweet.tweetID
        let tweetLikesRef = APIReference.tweets.child(tweetID).child("likes")

        if tweet.isLiked {
            // unlike
            // @todo use increment
            tweetLikesRef.setValue(tweet.likes - 1)
            APIReference.userLikes.child(uid).child(tweetID).removeValue { error, ref  in
                if let error = error {
                    completion(error, ref)
                    return
                }

                APIReference.tweetLikes.child(tweetID).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            // like
            tweetLikesRef.setValue(tweet.likes + 1)
            APIReference.userLikes.child(uid).updateChildValues([tweetID: 1]) { error, ref  in
                if let error = error {
                    completion(error, ref)
                    return
                }

                APIReference.tweetLikes.child(tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }

    func checkIfUserLiked(tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        APIReference.userLikes.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
