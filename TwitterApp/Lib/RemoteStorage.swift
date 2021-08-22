//
//  RemoteStorage.swift
//  TwitterApp
//
//  Created by andy on 22.08.2021.
//

import Foundation

protocol RemoteStorage {
    func downloadURL(completion: (URL?, Error?) -> Void)

    func putData(_ uploadData: Data, completion: ((Error?) -> Void)?)
}
