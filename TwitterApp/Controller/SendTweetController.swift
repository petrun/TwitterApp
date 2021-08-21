//
//  SendTweetController.swift
//  TwitterApp
//
//  Created by andy on 21.08.2021.
//

import UIKit

class SendTweetController: UIViewController {

    // MARK: - Properties

    private let user: User

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 16

        button.addTarget(self, action: #selector(handleSendTweet), for: .touchUpInside)

        return button
    }()

    private let profileImageView = UI.roundImageView(size: 48)

    private let captionTextView = CaptionTextView()

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Selectors

    @objc func handleCancel() {
        dismiss(animated: true)
    }

    @objc func handleSendTweet() {
        guard let caption = captionTextView.text, !caption.isEmpty else { return }

        TweetService.shared.uploadTweet(caption: caption) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return;
            }

            print("DEBUG: tweet success \(ref)")

            self.dismiss(animated: true)
        }
    }

    // MARK: - API

    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white

        configureNavigationBar()

        let stack = UIStackView(arrangedSubviews: [
            profileImageView,
            captionTextView
        ])
        stack.alignment = .top
        stack.axis = .horizontal
        stack.spacing = 12

        view.addSubview(stack)

        stack
            .top(to: view.safeAreaLayoutGuide.topAnchor, 16)
            .left(to: view.leftAnchor, 16)
            .right(to: view.rightAnchor, 16)

        profileImageView.sd_setImage(with: user.profileImageUrl)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }

}
