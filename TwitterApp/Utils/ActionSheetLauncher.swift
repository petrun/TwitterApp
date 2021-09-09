//
//  ActionSheetLauncher.swift
//  TwitterApp
//
//  Created by andy on 05.09.2021.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: ActionSheetOptions)
}

final class ActionSheetLauncher: NSObject {
    // MARK: - Properties

    weak var delegate: ActionSheetLauncherDelegate?

    private let user: User
    private let tableView = UITableView()
    private lazy var window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})!
    private var tableHeight: CGFloat {
        tableView.rowHeight * CGFloat(options.count) + 100
    }

    private lazy var options = ActionSheetViewModel(user: user).options

    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        )

        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)

        return button
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton) {
            $0.height = 50
            $0.left = 12
            $0.right = 12
            $0.centerY = view
        }
        cancelButton.layer.cornerRadius = 50 / 2

        return view
    }()

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user

        super.init()

        configureTableView()
    }

    // MARK: - Selectors

    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.3) { self.showTableView(false) }
    }

    // MARK: - Helpers

    func showTableView(_ shouldShow: Bool) {
        blackView.alpha = shouldShow ? 1 : 0
        tableView.frame.origin.y = window.frame.height - (shouldShow ? tableHeight : 0)
    }

    func show() {
        print("DEBUG: show action sheet for user \(user.username)")

        window.addSubview(blackView)
        blackView.frame = window.frame

        window.addSubview(tableView)
        tableView.frame = CGRect(
            x: 0,
            y: window.frame.height,
            width: window.frame.width,
            height: tableHeight
        )

        UIView.animate(withDuration: 0.3) { self.showTableView(true) }
    }

    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false

        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = options[indexPath.row]

        return cell
    }


}

// MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = self.options[indexPath.row]

        UIView.animate(withDuration: 0.3) {
            self.showTableView(false)
        } completion: {_ in
            self.delegate?.didSelect(option: option)
        }
    }
}
