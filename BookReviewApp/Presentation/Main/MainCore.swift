//
//  MainCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import Foundation

// MARK: - State
struct Main {
    struct State: Equatable {
        var searchState = Search.State()
        var booksState = Books.State()
        var detailViewItem: Book?
        var isLoading = false
    }
    
    enum Action {
        case search(Search.Action)
        case books(Books.Action)
        case loadingActive(Bool)
    }
    
    struct Environment {
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var booksClient: BookClient
    }

    static let reducer: Reducer<Main.State, Main.Action, Main.Environment> = .combine(
        Search.reducer.pullback(
            state: \Main.State.searchState,
            action: /Main.Action.search,
            environment: { _ in }
        ),
        Books.reducer.pullback(
            state: \Main.State.booksState,
            action: /Main.Action.books,
            environment: {
                Books.Environment(mainQueue: $0.mainQueue,
                                  booksClient: $0.booksClient
                )
            }
        ),
        .init { state, action, environment in
            switch action {
            case let .search(.searchQueryChanged(query)):
                return .init(value: .books(.request(option: state.searchState.option, query: query)))
                
            case .books(.request):
                return .init(value: .loadingActive(true))
                
            case .books(.response):
                return .init(value: .loadingActive(false))
                
            case let .loadingActive(isLoading):
                state.isLoading = isLoading
                return .none
                
            case let .books(.detail(book)):
                state.detailViewItem = book
                return .none
                
            default:
                return .none
            }
        }
    )
}
