//
//  BooksCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2023/01/06.
//

import ComposableArchitecture
import Foundation

struct Books {    
    struct State : Equatable {
        var items = [Book]()
        var isLoadingPage = false
        var currentPage = 1
        var pageSize = 1
        
        fileprivate func isLastItem(_ idx: Int) -> Bool {
            return idx == items.count - Calc.defaultOne
        }
        
        fileprivate var isMoreBooks: Bool {
            return pageSize > currentPage
        }
    }
    
    enum Action {
        case nextPage(idx: Int)
        case loadMore
        case loadingActive(Bool)
        case detail(with: Book)
    }
    
    static let reducer =
    Reducer<Books.State, Books.Action, Void> { state, action, _ in
        
        switch action {            
        case let .nextPage(idx):
            guard state.isLastItem(idx), state.isMoreBooks else {
                return .none
            }
            
            return .concatenate(
                .init(value: .loadingActive(true)),
                .init(value: .loadMore)
            )
            
        case .loadMore:
            state.currentPage += Calc.defaultOne
            return .none
            
        case let .loadingActive(isLoading):
            state.isLoadingPage = isLoading
            return .none
            
        default:
            return .none
        }
    }
}

// MARK: - Namespace

extension Books {
    private enum Calc {
        static let defaultOne = 1
    }
}
