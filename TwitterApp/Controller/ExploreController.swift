//
//  ExploreController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import UIKit

private let reuseIdentifier = "UserCell"

final class ExploreController: UITableViewController {
    // MARK: - Properties

    private var users = [User]() {
        didSet { tableView.reloadData() }
    }

    private var filteredUsers = [User]() {
        didSet { tableView.reloadData() }
    }

    private var inSearchMode: Bool {
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    private let searchController = UISearchController()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchUsers()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    // MARK: - API

    private func fetchUsers() {
        UserService.shared.fetchUsers { self.users = $0 }
    }

    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"

        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user"

        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDelegate/DataSource

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inSearchMode ? filteredUsers.count : users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell

        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]

        navigationController?.pushViewController(
            ProfileController(user: user),
            animated: true
        )
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter {
            $0.fullname.lowercased().contains(searchText) ||
            $0.username.lowercased().contains(searchText)
        }
    }
}
