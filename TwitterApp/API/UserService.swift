//
//  UserService.swift
//  TwitterApp
//
//  Created by andy on 20.08.2021.
//

import Firebase

struct UserService {
    static let shared = UserService()

    private init() {}

    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        APIReference.users.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: AnyObject] else { return }

            completion(User(uid: uid, dict: dict))
        }
    }

    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users: [User] = []

        APIReference.users.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }

            users.append(User(uid: snapshot.key, dict: dict))

            completion(users)
        }
    }

    func followUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let currentUserId = AuthService.shared.currentUserId else { return }

        APIReference.userFollowing.child(currentUserId).updateChildValues([uid: 1]) { error, ref in
            if let error = error {
                completion(error, ref)
                return
            }
            APIReference.userFollowers.child(uid).updateChildValues([currentUserId: 1], withCompletionBlock: completion)
        }
    }

    func unfollowUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let currentUserId = AuthService.shared.currentUserId else { return }

        APIReference.userFollowing.child(currentUserId).child(uid).removeValue { error, ref in
            if let error = error {
                completion(error, ref)
                return
            }
            APIReference.userFollowers.child(uid).child(currentUserId).removeValue(completionBlock: completion)
        }
    }

    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUserId = AuthService.shared.currentUserId else { return }

        APIReference.userFollowing.child(currentUserId).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        APIReference.userFollowers.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count

            APIReference.userFollowing.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count

                completion(UserRelationStats(followers: followers, following: following))
            }
        }
    }
}
