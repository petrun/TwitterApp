//
//  AuthService.swift
//  TwitterApp
//
//  Created by andy on 20.08.2021.
//

import Foundation
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let imageData: Data
}

struct UpdateUserCredentials {
    let fullname: String
    let username: String
    let bio: String
}

struct AuthService {
    static let shared = AuthService()

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    private init() {}

    func login(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let filename = NSUUID().uuidString
        let storageRef = APIReference.profileImages.child(filename)

        storageRef.putData(credentials.imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: error upload image: \(error.localizedDescription)")
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("DEBUG: error download image: \(error.localizedDescription)")
                    return
                }

                guard let profileImageUrl = url?.absoluteString else { return }

                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                        return
                    }

                    guard let uid = result?.user.uid else { return }

                    print("UID = \(uid)")

                    APIReference.users.child(uid).updateChildValues(
                        [
                            "email": credentials.email,
                            "username": credentials.username,
                            "fullname": credentials.fullname,
                            "profileImageUrl": profileImageUrl
                        ],
                        withCompletionBlock: completion
                    )
                }
            }
        }
    }
}
