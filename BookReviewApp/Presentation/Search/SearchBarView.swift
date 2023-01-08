//
//  SearchViewController.swift
//  BookReviewApp
//
//  Created by 김동현 on 2023/01/06.
//

import ComposableArchitecture
import SnapKit
import UIKit

class SearchBarView: UIView {
    private let searchBar = UISearchBar()
    
    private let store: Store<Search.State, Search.Action>
    private let viewStore: ViewStore<Search.State, Search.Action>
    
    init(frame: CGRect = CGRect(), with store: Store<Search.State, Search.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupViews() {
        self.addSubview(searchBar)
        
        searchBar.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
    }
}

// MARK: -  Delegate

extension SearchBarView: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let query = searchBar.text, query.isEmpty == false else { return }
        viewStore.send(.searchQueryChanged(query))
    }
}
