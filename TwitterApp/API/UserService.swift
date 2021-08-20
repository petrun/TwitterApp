//
//  UserService.swift
//  TwitterApp
//
//  Created by andy on 20.08.2021.
//

import Firebase

struct UserService {
    static let shared = UserService()

    func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else { return }

            completion(User(uid: uid, dict: dict))
        }
    }
}
