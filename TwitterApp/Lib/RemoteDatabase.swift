//
//  DB.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import Foundation

protocol RemoteDatabase {
    func create(table: String, values: [AnyHashable: Any], completion: (Error?) -> Void)

    func update(table: String, uid: String, values: [AnyHashable: Any], completion: (Error?) -> Void)

    func observeSingleEvent(table: String, uid: String, completion: @escaping ([String: AnyObject]) -> Void)

    func observe(table: String, uid: String, completion: @escaping ([String: AnyObject]) -> Void)
}
