//
//  ConversationsController.swift
//  TwitterApp
//
//  Created by andy on 16.08.2021.
//

import UIKit

final class ConversationsController: UIViewController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white

        navigationItem.title = "Messages"
    }
}
