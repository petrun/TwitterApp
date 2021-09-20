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

    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }

    private var tweets: [Tweet] = []
    private var replies: [Tweet] = []
    private var likedTweets: [Tweet] = []

    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets: return tweets
        case .replies: return replies
        case .likes: return likedTweets
        }
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

        fetchLikedTweets()
        fetchReplies()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - API

    private func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) {
            self.tweets = $0
            self.collectionView.reloadData()
        }
    }

    private func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { self.likedTweets = $0 }
    }

    private func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { self.replies = $0 }
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

        if let tabHeight = tabBarController?.tabBar.frame.height {
            collectionView.contentInset.bottom = tabHeight
        }
    }
}

// MARK: UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentDataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! TweetCell

        cell.tweet = currentDataSource[indexPath.row]

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
            height: TweetViewModel(tweet: currentDataSource[indexPath.row]).height(forWidth: view.frame.width) + 72
        )
    }
}

// MARK: - UICollectionViewDelegate/DataSource

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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard selectedFilter == .tweets else { return }

        navigationController?.pushViewController(
            TweetController(tweet: currentDataSource[indexPath.row]),
            animated: true
        )
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func handleSelect(filter: ProfileFilterOptions) {
        selectedFilter = filter
    }

    func handleEditProfile(_ header: ProfileHeader) {
        let editProfileController = EditProfileController(user: user)
        editProfileController.delegate = self
        let nav = UINavigationController(rootViewController: editProfileController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
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

                NotificationService.shared.sendNotification(type: .follow, toUser: self.user)
            }
        }
    }

    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        collectionView.reloadData()
    }
}
