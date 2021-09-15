//
// Created by andy on 14.09.2021.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func handleChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    // MARK: - Properties

    private var user: User
    weak var delegate: EditProfileHeaderDelegate?

    var profileImageView: UIImageView = {
        let imageView = UI.roundImageView(size: 100)
        imageView.border(.white, width: 3)
        imageView.layer.cornerRadius = 100 / 2

        return imageView
    }()

    lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)

        return button
    }()

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(frame: .zero)

        backgroundColor = .twitterBlue

        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)

        addSubview(changePhotoButton) {
            $0.centerX = self
            $0.topAnchor = profileImageView.bottomAnchor + 8
        }

        profileImageView.sd_setImage(with: user.profileImageUrl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleChangePhoto() {
        print("Tap handleChangePhoto")
        delegate?.handleChangeProfilePhoto()
    }
}
