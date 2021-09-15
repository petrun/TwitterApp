//
//  SendTweetController.swift
//  TwitterApp
//
//  Created by andy on 21.08.2021.
//

import ActiveLabel
import UIKit

class SendTweetController: UIViewController {
    // MARK: - Properties

    private let user: User
    private let type: TweetType

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSendTweet), for: .touchUpInside)

        return button
    }()

    private let profileImageView = UI.roundImageView(size: 48)

    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.enabledTypes = [.mention]
        label.mentionColor = .twitterBlue

        return label
    }()

    private let captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.height(300)

        return textView
    }()

    // MARK: - Lifecycle

    init(user: User, type: TweetType) {
        self.user = user
        self.type = type

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    // MARK: - Selectors

    @objc func handleCancel() {
        dismiss(animated: true)
    }

    @objc func handleSendTweet() {
        guard let caption = captionTextView.text, !caption.isEmpty else { return }

        switch type {
        case .tweet:
            TweetService.shared.createTweet(caption: caption) { error, _ in
                if let error = error {
                    print("DEBUG: Failed to sent tweet with error \(error.localizedDescription)")
                    return
                }

                self.dismiss(animated: true)
            }
        case .reply(let tweet):
            TweetService.shared.reply(to: tweet, caption: caption) { error, _ in
                if let error = error {
                    print("DEBUG: Failed to reply to tweet \(tweet.tweetID) with error \(error.localizedDescription)")
                    return
                }

                NotificationService.shared.sendNotification(type: .reply, tweet: tweet)

                self.dismiss(animated: true)
            }
        }
    }

    // MARK: - API

    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white

        let viewModel = SendTweetViewModel(type: type)

        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)

        replyLabel.text = viewModel.replyText
        replyLabel.isHidden = !viewModel.isShowReplyLabel

        captionTextView.placeholderLabel.text = viewModel.placeholderText

        view.addSubview(
            UI.VStack(
                arrangedSubviews: [
                    replyLabel,
                    UI.HStack(
                        arrangedSubviews: [profileImageView, captionTextView],
                        spacing: 12,
                        alignment: .leading
                    )
                ],
                spacing: 12
            )
        ) {
            $0.topAnchor = view.safeAreaLayoutGuide.topAnchor + 8
            $0.leftAnchor = view.leftAnchor + 8
            $0.rightAnchor = view.rightAnchor + 8
        }

        profileImageView.sd_setImage(with: user.profileImageUrl)

        replyLabel.handleMentionTap { _ in
            self.navigationController?.pushViewController(
                ProfileController(user: self.user),
                animated: true
            )
        }
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(handleCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
