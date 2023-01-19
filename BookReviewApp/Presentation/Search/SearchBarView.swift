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
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pickerView, searchBar])
        stackView.axis = .horizontal
        stackView.spacing = Size.spacing
        
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        return searchBar
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
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
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
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

extension SearchBarView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Calc.defaultOne
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Options.Search.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Options.Search.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewStore.send(.searchOptionChanged(Options.Search.allCases[row]))
    }
}

extension SearchBarView {
    enum Size {
        static let spacing: CGFloat = 10
    }
    
    enum Calc {
        static let defaultOne = 1
    }
}
