//
//  LoadingOrErrorView.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/29.
//

import UIKit

class LoadingOrErrorView: UIView {
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = .black
        indicatorView.style = .large
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    private lazy var errorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, retryButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다시 시도", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(white: 99/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(48)
        }
        return button
    }()

    init() {
        super.init(frame: .zero)

        isHidden = true

        addSubview(indicatorView)
        addSubview(errorStackView)

        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        errorStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func clear() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        errorStackView.isHidden = true
    }

    func showSuccess() {
        clear()
        isHidden = true
    }

    func showLoading() {
        clear()
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        isHidden = false
    }

    func showError(error: Error) {
        clear()
        errorStackView.isHidden = false
        errorLabel.text = error.localizedDescription
        isHidden = false
    }
}
