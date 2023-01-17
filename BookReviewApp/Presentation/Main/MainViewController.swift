//
//  MainViewController.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import Combine
import ComposableArchitecture
import SnapKit
import UIKit

class MainViewController: UIViewController {
    private let loadingView = LoadingOrErrorView()

    private let store: Store<Main.State, Main.Action>
    private let viewStore: ViewStore<Main.State, Main.Action>
    private var cancellables: Set<AnyCancellable> = []
    
    init(with store: Store<Main.State, Main.Action>) {
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
        bindViewStore()
    }
}

// MARK: - Stores

extension MainViewController {
    private var searchStore: Store<Search.State, Search.Action> {
        return store.scope(
            state: { $0.searchState },
            action: Main.Action.search
        )
    }
    
    private var booksStore: Store<Books.State, Books.Action> {
        return store.scope(
            state: { $0.booksState },
            action: Main.Action.books
        )
    }
}

// MARK: - Namespace

extension MainViewController {
    enum Size {
        static let searchBarWidth: CGFloat = 300
        static let searchBarHeight: CGFloat = 200
        static let collectionOffset: CGFloat = 10
        static let collectionInset: CGFloat = 10
    }
}


// MARK: - Private Methods

extension MainViewController {
    private func setupViews() {
        let searchBar = SearchBarView(with: searchStore)
        let booksView = BooksView(with: booksStore)
        
        view.addSubview(searchBar)
        view.addSubview(booksView)
        view.addSubview(loadingView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Size.searchBarWidth)
            $0.height.equalTo(Size.searchBarHeight)
        }
        booksView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(Size.collectionOffset)
            $0.bottom.equalToSuperview().inset(Size.collectionInset)
            $0.leading.trailing.equalToSuperview()
        }
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bindLoadingView(at: booksView)
    }
    
    private func bindLoadingView(at targetView: UIView) {
        viewStore.publisher.isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    targetView.isHidden = true
                    self?.loadingView.showLoading()
                } else {
                    targetView.isHidden = false
                    self?.loadingView.showSuccess()
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func bindViewStore() {
        viewStore.publisher.detailViewItem
            .dropFirst()
            .compactMap { $0 }
            .sink {
                self.navigationController?.pushViewController(
                    DetailViewController(with: $0),
                    animated: true
                )
            }
            .store(in: &self.cancellables)
    }
}
