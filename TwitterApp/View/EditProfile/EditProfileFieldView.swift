//
// Created by andy on 14.09.2021.
//

import UIKit

protocol EditProfileFieldDelegate: class {
    func handleUpdateUserInfo(_ view: EditProfileFieldView)
}

class EditProfileFieldView: UIView {
    // MARK: - Properties

    var viewModel: EditProfileViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            infoTextField.isHidden = viewModel.hideTextField
            bioTextView.isHidden = viewModel.hideTextView

            titleLabel.text = viewModel.titleText

            infoTextField.text = viewModel.optionValue
            bioTextView.text = viewModel.optionValue
            bioTextView.placeholderLabel.isHidden = viewModel.hidePlaceholderLabel
        }
    }

    weak var delegate: EditProfileFieldDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)

        return textField
    }()

    let bioTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderLabel.text = "Bio"
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .twitterBlue

        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel) {
            $0.width = 100
            $0.top = 18
            $0.left = 16
        }

        addSubview(infoTextField) {
            $0.top = 4
            $0.leftAnchor = titleLabel.rightAnchor + 16
            $0.right = 8
            $0.bottom = 0
        }

        addSubview(bioTextView) {
            $0.top = 4
            $0.leftAnchor = titleLabel.rightAnchor + 12
            $0.right = 8
            $0.bottom = 0
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateUserInfo),
            name: UITextView.textDidEndEditingNotification,
            object: bioTextView
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleUpdateUserInfo() {
        delegate?.handleUpdateUserInfo(self)
    }
}
