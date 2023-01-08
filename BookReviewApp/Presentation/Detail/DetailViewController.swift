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
        let stackView = UIStackView(arrangedSubviews: [thumbnailView, titleLabel, authorsLabel])
        stackView.spacing = Size.stackSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(Size.thumbnailWidth)
            $0.height.equalTo(Size.thumbnailHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(Size.labelHorizontalInset)
            $0.height.equalTo(Size.labelHeight)
        }
        
        authorsLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(Size.labelHorizontalInset)
            $0.height.equalTo(Size.labelHeight)
        }
        
        return stackView
    }()
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let authorsLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let book: Book
    
    init(with book: Book) {
        self.book = book
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
        static let stackSpacing: CGFloat = 10
        static let thumbnailWidth: CGFloat = 160
        static let thumbnailHeight: CGFloat = 200
        static let labelHorizontalInset: CGFloat = 20
        static let labelHeight: CGFloat = 40
    }
    
    enum Label {
        static let title = "책 제목"
        static let authorsName = "공동 저자"
        static let colon = ": "
        static let comma = ", "
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
        thumbnailView.setBookCover(with: book.thumbnailIdx)
        titleLabel.text = Label.title + Label.colon + book.title
        authorsLabel.text = Label.authorsName + Label.colon + book.authorsName.joined(separator: Label.comma)
    }
}
