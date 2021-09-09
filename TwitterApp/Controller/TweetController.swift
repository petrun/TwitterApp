//
//  TweetController.swift
//  TwitterApp
//
//  Created by andy on 03.09.2021.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerReuseIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    // MARK: - Properties

    private let tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Lifecycle

    init(tweet: Tweet) {
        self.tweet = tweet

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchReplies()
    }

    func configureCollectionView() {
        collectionView.backgroundColor = .white

        collectionView.register(
            TweetHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerReuseIdentifier
        )
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: - API

    func fetchReplies() {
        TweetService.shared.fetchReplies(for: tweet) { replies in
            self.replies = replies
        }
    }
}

// MARK: UICollectionViewDataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        replies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! TweetCell

        cell.tweet = replies[indexPath.row]

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(
            width: view.frame.width,
            height: TweetViewModel(tweet: tweet).height(forWidth: view.frame.width) + 300
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - UICollectionViewDelegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let tweetHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerReuseIdentifier,
            for: indexPath
        ) as! TweetHeader

        tweetHeader.tweet = tweet
        tweetHeader.delegate = self

        return tweetHeader
    }
}

// MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    private func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }

    func showActionSheet() {
        var user = tweet.user
        if user.isCurrentUser {
            showActionSheet(forUser: user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

// MARK: - ActionSheetLauncherDelegate

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, _ in
                if let error = error {
                    print("Follow user error: \(error.localizedDescription)")
                    return
                }
                print("DEBUG: Did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, _ in
                if let error = error {
                    print("Unfollow user error: \(error.localizedDescription)")
                    return
                }
                print("DEBUG: Did unfollow user \(user.username)")
            }
        case .report:
            print("DEBUG: Call send report")
        case .delete:
            print("DEBUG: Call delete tweet")
        }
    }
}
