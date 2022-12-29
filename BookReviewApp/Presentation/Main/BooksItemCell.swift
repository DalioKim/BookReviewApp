//
//  BooksItemCell.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import UIKit
import Kingfisher

class BooksItemCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: BooksItemCell.self)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = Size.spacing
        stackView.alignment = .center
        
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(Size.Thumbnail.width)
            $0.height.equalTo(Size.Thumbnail.height)
        }
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = Style.Title.lines
        titleLabel.textAlignment = .left
        titleLabel.font = Style.Title.font
        titleLabel.lineBreakMode = Style.Title.lineBreakMode
        return titleLabel
    }()
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        thumbnailView.image = nil
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Size.verticalPadding)
        }
    }
    
    func bind(with book: Book) {
        titleLabel.text = book.title
        guard let idx = book.thumbnailIdx,
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

// MARK: - NameSpace

extension BooksItemCell {
    enum Size {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let spacing: CGFloat = 10
        static let height: CGFloat = 100
        
        enum Thumbnail {
            static let width: CGFloat = 40
            static let height: CGFloat = 60
        }
    }
    
    enum Style {
        enum Title {
            static let font = UIFont.systemFont(ofSize: 16)
            static let lines = 10
            static let lineBreakMode: NSLineBreakMode = .byTruncatingTail
        }
    }
}
