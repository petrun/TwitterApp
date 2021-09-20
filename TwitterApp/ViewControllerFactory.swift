//
// Created by andy on 17.09.2021.
//

import UIKit

struct ViewControllerFactory {
    static let shared = ViewControllerFactory()

    func makeProfileViewController(user: User) -> UIViewController {
        ProfileController(user: user)
    }
}
