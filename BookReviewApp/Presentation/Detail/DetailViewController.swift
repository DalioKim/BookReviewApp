//
//  DetailViewController.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/29.
//

import UIKit
import ComposableArchitecture

class DetailViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        thumbnailView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let store: Store<DetailState, DetailAction>
    private let viewStore: ViewStore<DetailState, DetailAction>
    
    init(store: Store<DetailState, DetailAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContent()
    }
}

// MARK: - Namespace

extension DetailViewController {
    enum Size {
        static let stackHorizontalInset: CGFloat = 20
        static let stackVerticalInset: CGFloat = 100
    }
}
    
// MARK: - Private Methods

extension DetailViewController {
    private func setupViews() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.stackHorizontalInset)
            $0.top.bottom.equalToSuperview().inset(Size.stackVerticalInset)
        }
    }
    
    private func setupContent() {
        titleLabel.text = viewStore.state.book.title
        guard let idx = viewStore.state.book.thumbnailIdx,
              let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String,
              let url = URL(string: imageBaseURL + "/b/id/\(idx)-S.jpg") else { return }
        
        thumbnailView.kf.setImage(
            with: url,
            placeholder: nil,
            options: .none,
            completionHandler: nil
        )
    }
}