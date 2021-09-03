//
//  RegistrationController.swift
//  TwitterApp
//
//  Created by andy on 18.08.2021.
//

import Firebase
import UIKit

class RegistrationController: UIViewController {
    // MARK: - Properties

    private let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

        return imagePicker
    }()

    private var profileImage: UIImage?

    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true

        return button
    }()

    private lazy var emailContainerView: UIView = {
        UI.inputContainerView(
            image: UIImage(named: "ic_mail_outline_white_2x-1")!,
            textField: emailTextField
        )
    }()

    private lazy var passwordContainerView: UIView = {
        UI.inputContainerView(
            image: UIImage(named: "ic_lock_outline_white_2x")!,
            textField: passwordTextField
        )
    }()

    private lazy var fullnameContainerView: UIView = {
        UI.inputContainerView(
            image: UIImage(named: "ic_person_outline_white_2x")!,
            textField: fullnameTextField
        )
    }()

    private lazy var usernameContainerView: UIView = {
        UI.inputContainerView(
            image: UIImage(named: "ic_person_outline_white_2x")!,
            textField: usernameTextField
        )
    }()

    private let emailTextField = UI.textField(placeholder: "Email")

    private let passwordTextField: UITextField  = {
        let tf = UI.textField(placeholder: "Password")
        tf.isSecureTextEntry = true

        return tf
    }()

    private let fullnameTextField = UI.textField(placeholder: "Full Name")

    private let usernameTextField = UI.textField(placeholder: "Username")

    private let signUpButton: UIButton = {
        let button = UI.submitButton(title: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

        return button
    }()

    private let alreadyHaveAccountButton: UIButton = {
        let button = UI.attributedButton("Already have an account?", "Login")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Selectors

    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleSignUp() {
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image...")
            return
        }

        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let fullname = fullnameTextField.text,
            let username = usernameTextField.text?.lowercased(),
            let imageData = profileImage.jpegData(compressionQuality: 0.3)
        else {
            return
        }

        AuthService.shared.registerUser(credentials: AuthCredentials(
            email: email,
            password: password,
            fullname: fullname,
            username: username,
            imageData: imageData
        )) { (error, ref) in
            print("User register completion ...")

            if let error = error {
                print("Auth error: \(error.localizedDescription)")
                return
            }

            guard
                let tab = UIApplication.shared.windows
                    .first(where: {$0.isKeyWindow})?.rootViewController as? MainTabBarController
            else {
                return
            }

            tab.authUserAndConfigureUI()

            self.dismiss(animated: true)
        }

        print("Email = \(email) Password = \(password)")
    }

    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true)
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .twitterBlue

        // AddPhotoButton
        view.addSubview(addPhotoButton)
        addPhotoButton
            .centerX(
                in: view,
                topAnchor: view.safeAreaLayoutGuide.topAnchor
            )
            .size(width: 150, height: 150)
            .layer.cornerRadius = 150 / 2
//        addPhotoButton.layer.masksToBounds = true

        // Stack
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            passwordContainerView,
            fullnameContainerView,
            usernameContainerView,
            signUpButton,
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually

        view.addSubview(stack)

        stack
            .top(to: addPhotoButton.bottomAnchor, 16)
            .left(to: view.leftAnchor, 16)
            .right(to: view.rightAnchor, 16)

        // AlreadyHaveAccountButton
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor)
            .centerX(in: view)

        imagePicker.delegate = self
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        profileImage = image

        addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)

        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3

        dismiss(animated: true)
    }
}
