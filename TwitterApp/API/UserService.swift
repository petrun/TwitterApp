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
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else { return }

            completion(User(uid: uid, dict: dict))
        }
    }
}
