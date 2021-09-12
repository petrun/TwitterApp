//
//  FeedController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import SDWebImage
import UIKit

private let reuseIdentifier = "TweetCell"

final class FeedController: UICollectionViewController {
    // MARK: - Properties

    var user: User? {
        didSet { configureLeftBarButton() }
    }

    // @todo reload item
    private var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchTweets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    // MARK: - API

    private func fetchTweets() {
        TweetService.shared.fetchTweets {
            self.tweets = $0
            self.checkIfUserLiked(tweets: self.tweets)
        }
    }

    // @todo move to service
    private func checkIfUserLiked(tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLiked(tweet: tweet) {
                guard $0 == true else { return }
                self.tweets[index].isLiked = $0
            }
        }
    }

    // MARK: - Helpers

    private func configureUI() {
        collectionView.backgroundColor = .white

        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.size(width: 44, height: 44)
        navigationItem.titleView = imageView
    }

    private func configureLeftBarButton() {
        guard let user = user else { return }

        let profileImageView = UI.roundImageView(size: 32)
        profileImageView.sd_setImage(with: user.profileImageUrl)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tweets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! TweetCell

        cell.delegate = self
        cell.tweet = tweets[indexPath.row]

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            TweetController(tweet: tweets[indexPath.row]),
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: view.frame.width,
            height: TweetViewModel(tweet: tweets[indexPath.row]).height(forWidth: view.frame.width) + 72
        )
    }
}

// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        guard var tweet = cell.tweet else { return }

        TweetService.shared.like(tweet: tweet) { error, _ in
            if let error = error {
                print("DEBUG: like error \(error.localizedDescription)")
                return
            }

            tweet.isLiked.toggle()
            tweet.likes = tweet.isLiked ? tweet.likes + 1 : tweet.likes - 1

            guard let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) else { return }

            self.tweets[index] = tweet

            if tweet.isLiked {
                NotificationService.shared.sendNotification(type: .like, tweet: tweet)
            }
        }
    }

    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }

        let nav = UINavigationController(
            rootViewController: SendTweetController(user: tweet.user, type: .reply(tweet))
        )
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }

        navigationController?.pushViewController(
            ProfileController(user: user),
            animated: true
        )
    }
}
