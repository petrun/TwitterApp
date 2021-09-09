//
//  LoginController.swift
//  TwitterApp
//
//  Created by andy on 18.08.2021.
//

import UIKit

class LoginController: UIViewController {
    // MARK: - Properties

    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.image = UIImage(named: "TwitterLogo")

        return logo
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

    private let emailTextField = UI.textField(placeholder: "Email")

    private let passwordTextField: UITextField  = {
        let textField = UI.textField(placeholder: "Password")
        textField.isSecureTextEntry = true

        return textField
    }()

    private let loginButton: UIButton = {
        let button = UI.submitButton(title: "Login")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        return button
    }()

    private let dontHaveAccountButton: UIButton = {
        let button = UI.attributedButton("Don't have an account?", "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Selectors

    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        AuthService.shared.login(email: email, password: password) { _, error in
            if let error = error {
                print("Auth error: \(error.localizedDescription)")
                return
            }

            guard
                let tab = UIApplication.shared.getRootViewController() as? MainTabBarController
            else { return }

            tab.authUserAndConfigureUI()

            self.dismiss(animated: true)
        }
    }

    @objc func handleShowSignUp() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black

        // Logo
        view.addSubview(logoImageView)
        logoImageView
            .centerX(in: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
            .size(width: 150, height: 150)

        // Stack
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            passwordContainerView,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually

        view.addSubview(stack)

        stack
            .top(to: logoImageView.bottomAnchor, 16)
            .left(to: view.leftAnchor, 16)
            .right(to: view.rightAnchor, 16)

        // DontHaveAccountButton
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.bottom(to: view.safeAreaLayoutGuide.bottomAnchor)

        dontHaveAccountButton.centerX(in: view)
    }
}
