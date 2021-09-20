//
// Created by andy on 14.09.2021.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio

    var description: String {
        switch self {
        case .fullname: return "Name"
        case .username: return "Username"
        case .bio: return "Bio"
        }
    }
}

struct EditProfileViewModel {
    private let user: User
    let option: EditProfileOptions

    var hideTextField: Bool {
        option == .bio
    }

    var hideTextView: Bool {
        option != .bio
    }

    var hidePlaceholderLabel: Bool {
        !user.bio.isEmpty
    }

    var titleText: String {
        option.description
    }

    var optionValue: String? {
        switch option {
        case .fullname: return user.fullname
        case .username: return user.username
        case .bio: return user.bio
        }
    }

    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
