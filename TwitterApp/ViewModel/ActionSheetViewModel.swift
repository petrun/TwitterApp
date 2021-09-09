//
//  ActionSheetViewModel.swift
//  TwitterApp
//
//  Created by andy on 08.09.2021.
//

import Foundation

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete

    var description: String {
        switch self {
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        }
    }
}

struct ActionSheetViewModel {
    private let user: User

    var options: [ActionSheetOptions] {
        user.isCurrentUser ?
            [.delete] :
            [
                user.isFollowed ? .unfollow(user) : .follow(user),
                .report,
            ]
    }

    init(user: User) {
        self.user = user
    }
}
