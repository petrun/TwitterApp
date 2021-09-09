//
//  ProfileController.swift
//  TwitterApp
//
//  Created by andy on 23.08.2021.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerReuseIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    // MARK: - Properties

    private var user: User

    private var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - API

    private func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }

    private func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) {
            self.user.isFollowed = $0
            self.collectionView.reloadData()
        }
    }

    private func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) {
            self.user.stats = $0
            self.collectionView.reloadData()
        }
    }

    // MARK: - Helpers

    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerReuseIdentifier
        )
    }
}

// MARK: UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tweets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! TweetCell

        cell.tweet = tweets[indexPath.row]

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: view.frame.width,
            height: TweetViewModel(tweet: tweets[indexPath.row]).height(forWidth: view.frame.width) + 72
        )
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let profileHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerReuseIdentifier,
            for: indexPath
        ) as! ProfileHeader

        profileHeader.user = user
        profileHeader.delegate = self

        return profileHeader
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func handleEditProfile(_ header: ProfileHeader) {
        print("DEBUG: Call edit profile")
    }

    func handleFollow(_ header: ProfileHeader) {
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, _ in
                if let error = error {
                    print("DEBUG: Unfollow user error \(error.localizedDescription)")
                    return
                }
                self.user.isFollowed = false
                self.user.stats?.followers -= 1
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, _ in
                if let error = error {
                    print("DEBUG: Follow user error \(error.localizedDescription)")
                    return
                }
                self.user.isFollowed = true
                self.user.stats?.followers += 1
                self.collectionView.reloadData()
            }
        }
    }

    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}
