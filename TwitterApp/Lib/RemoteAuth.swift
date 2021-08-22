//
//  RemoteAuth.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import Foundation

struct NewUser {
    let uid: String
}

protocol RemoteAuth {
    func createUser(email: String, password: String, completion: ((NewUser?, Error?) -> Void)?)

    func signIn(email: String, password: String, completion: ((Error?) -> Void)?)
}
