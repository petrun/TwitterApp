//
// Created by andy on 14.09.2021.
//

import UIKit

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UIViewController {
    // MARK: - Properties

    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let options = EditProfileOptions.allCases
    private let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

        return imagePicker
    }()

    private var userInfoChanged = false

    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }

    weak var delegate: EditProfileControllerDelegate?

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureUI()
        configureImagePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleCancel() {
        dismiss(animated: true)
    }

    @objc func handleDone() {
        view.endEditing(true)
        guard selectedImage != nil || userInfoChanged else { return }

        updateUserData()
    }

    // MARK: - API

    private func updateUserData() {
        storeProfileImage {
            self.storeUserData {
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
    }

    private func storeUserData(completion: @escaping () -> Void) {
        if !userInfoChanged { completion(); return }

        UserService.shared.updateUserData(
            credentials: UpdateUserCredentials(
                fullname: user.fullname,
                username: user.username,
                bio: user.bio
            )
        ) { error, _ in
            if let error = error {
                print("DEBUG: Cant updateUserData \(error.localizedDescription)")
                return
            }

            completion()
        }
    }

    private func storeProfileImage(completion: @escaping () -> Void) {
        guard let image = selectedImage else { completion(); return }

        UserService.shared.updateProfileImage(image: image) {
            self.user.profileImageUrl = $0
            completion()
        }
    }

    // MARK: - Helpers

    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white

        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(handleCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(handleDone)
        )
    }

    private func configureUI() {
        view.backgroundColor = .white

        view.addSubview(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self

        let stack = UI.VStack(arrangedSubviews: [
            createProfileFieldView(option: .username, height: 48),
            createProfileFieldView(option: .fullname, height: 48),
            createProfileFieldView(option: .bio, height: 100)
        ])

        view.addSubview(stack) {
            $0.topAnchor = headerView.bottomAnchor
            $0.left = 0
            $0.right = 0
        }
    }

    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    private func createProfileFieldView(option: EditProfileOptions, height: CGFloat) -> UIView {
        let view = EditProfileFieldView(frame: .zero)
            view.viewModel = EditProfileViewModel(user: user, option: option)
            view.delegate = self
            view.height(height)

        return view
    }
}

// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func handleChangeProfilePhoto() {
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        selectedImage = image

        dismiss(animated: true)
    }
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileFieldDelegate {
    func handleUpdateUserInfo(_ view: EditProfileFieldView) {
        guard let viewModel = view.viewModel else { return }

        switch viewModel.option {
        case .fullname:
            guard let fullname = view.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = view.infoTextField.text else { return }
            user.username = username
        case .bio:
            user.bio = view.bioTextView.text
        }

        userInfoChanged = true

        print("DEBUG: user updated: \(user)")
    }
}
