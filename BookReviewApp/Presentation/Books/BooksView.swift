//
//  BooksView.swift
//  BookReviewApp
//
//  Created by 김동현 on 2023/01/06.
//

import Combine
import ComposableArchitecture
import SnapKit
import UIKit

class BooksView: UIView {
    private let loadingView = LoadingOrErrorView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Size.verticalPadding,
                                           left: Size.horizontalPadding,
                                           bottom: Size.verticalPadding,
                                           right: Size.horizontalPadding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BooksItemCell.self, forCellWithReuseIdentifier: BooksItemCell.className)
        
        return collectionView
    }()
    
    private let store: Store<Books.State, Books.Action>
    private let viewStore: ViewStore<Books.State, Books.Action>
    private var cancellables: Set<AnyCancellable> = []
    
    init(frame: CGRect = CGRect(), with store: Store<Books.State, Books.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(frame: frame)
        
        setupViews()
        bindDelegate()
        bindViewStore()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(collectionView)
        self.addSubview(loadingView)

        collectionView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        loadingView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Size.LoadingView.height)
        }
    }
    
    private func bindDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func bindViewStore() {
        viewStore.publisher.books
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &self.cancellables)
        
        viewStore.publisher.isLoadingPage
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.showLoading()
                } else {
                    self?.loadingView.showSuccess()
                }
            }
            .store(in: &self.cancellables)
    }
}

// MARK: -  NameSpaces

extension BooksView {
    enum Size {
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
        
        enum LoadingView {
            static let height: CGFloat = 20
        }
        
        enum Item {
            static let height: CGFloat = 200
        }

    }
}

// MARK: -  Delegate

extension BooksView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewStore.state.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksItemCell.className, for: indexPath) as? BooksItemCell else { fatalError() }
        
        let book = viewStore.state.books[indexPath.item]
        cell.bind(with: book)
        viewStore.send(.nextPage(idx: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: Size.Item.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = viewStore.state.books[indexPath.row]
        viewStore.send(.detail(with: book))
    }
}
