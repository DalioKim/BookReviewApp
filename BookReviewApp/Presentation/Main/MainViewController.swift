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
    private let searchBar = UISearchBar()
    private let searchLoadingOrErrorView = LoadingOrErrorView()
    private let pageLoadingOrErrorView = LoadingOrErrorView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Size.verticalPadding,
                                           left: Size.horizontalPadding,
                                           bottom: Size.verticalPadding,
                                           right: Size.horizontalPadding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BooksItemCell.self, forCellWithReuseIdentifier: "BooksItemCell")
        
        return collectionView
    }()
    
    private let store: Store<MainState, MainAction>
    private let viewStore: ViewStore<MainState, MainAction>
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: Store<MainState, MainAction>) {
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
        bindSubViewDelegate()
        bindViewStore()
    }
}

// MARK: - Namespace

extension MainViewController {
    enum Size {
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
        static let searchBarWidth: CGFloat = 200
        static let searchBarHeight: CGFloat = 40
        static let collectionOffset: CGFloat = 10
        static let collectionInset: CGFloat = 10
        static let itemHeight: CGFloat = 100
    }
}

// MARK: - Private Methods

extension MainViewController {
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(searchLoadingOrErrorView)
        view.addSubview(pageLoadingOrErrorView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Size.searchBarWidth)
            $0.height.equalTo(Size.searchBarHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(Size.collectionOffset)
            $0.bottom.equalToSuperview().inset(Size.collectionInset)
            $0.leading.trailing.equalToSuperview()
        }
        
        searchLoadingOrErrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageLoadingOrErrorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    private func bindSubViewDelegate() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func bindViewStore() {
        viewStore.publisher.books
            .sink(receiveValue: { [weak self] _ in self?.collectionView.reloadData() })
            .store(in: &self.cancellables)
        
        viewStore.publisher.isLoadingSearchResults
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.collectionView.isHidden = true
                    self?.searchLoadingOrErrorView.showLoading()
                } else {
                    self?.collectionView.isHidden = false
                    self?.searchLoadingOrErrorView.showSuccess()
                }
            }
            .store(in: &self.cancellables)
        
        viewStore.publisher.isLoadingPage
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.pageLoadingOrErrorView.showLoading()
                } else {
                    self?.pageLoadingOrErrorView.showSuccess()
                }
            }
            .store(in: &self.cancellables)
    }
}

// MARK: -  Delegate

extension MainViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let query = searchBar.text, query.isEmpty == false else { return }
        viewStore.send(.searchQueryChanged(query))
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewStore.state.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksItemCell.reuseIdentifier, for: indexPath) as? BooksItemCell else { fatalError() }
        
        let detailState = viewStore.state.books[indexPath.item]
        cell.bind(with: detailState.book)
        viewStore.send(.retrieveNextPageIfNeeded(currentItem: detailState.id))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: Size.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let books = viewStore.state.books[indexPath.row]
        
        self.navigationController?.pushViewController(
            DetailViewController(
                store: self.store.scope(
                    state: \.books[indexPath.row],
                    action: { .moveDetail(id: books.id, action: $0) }
                )
            ),
            animated: true
        )
    }
}
