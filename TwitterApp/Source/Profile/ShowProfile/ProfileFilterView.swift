//
//  ProfileFilterView.swift
//  TwitterApp
//
//  Created by andy on 27.08.2021.
//

import UIKit

private let reuseIdentifier = "ProfileFilterCell"

protocol ProfileFilterViewDelegate: class {
    func selectFilter(_ filter: ProfileFilterOptions)
}

class ProfileFilterView: UIView {
    // MARK: - Properties

    let filters = ProfileFilterOptions.allCases

    weak var delegate: ProfileFilterViewDelegate?

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue

        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )

        addSubview(collectionView)
        collectionView.fill(view: self)
    }

    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView
            .left(to: leftAnchor)
            .bottom(to: bottomAnchor)
            .width(frame.width / CGFloat(filters.count))
            .height(2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! ProfileFilterCell

        cell.titleLabel.text = filters[indexPath.row].description

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }

        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }

        delegate?.selectFilter(filters[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: frame.width / CGFloat(filters.count), height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
