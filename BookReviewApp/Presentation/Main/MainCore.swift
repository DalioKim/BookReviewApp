//
//  MainCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import Foundation

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
        case request
        case response(Result<BookResponse, ServiceError>)
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
            environment: { _ in }
        ),
        .init { state, action, environment in
            struct MainCancelId: Hashable {}
            
            switch action {
            case .request:
                return environment.booksClient
                    .search(state.searchState.option, state.searchState.word, state.booksState.currentPage)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Main.Action.response)
                    .cancellable(id: MainCancelId())
                
            case let .response(.success(result)):
                state.booksState.pageSize = result.searchResultsCount / Calc.countOfItemsPerPage
                state.booksState.items += result.items
                
                return .merge(
                    .init(value: .loadingActive(false)),
                    .init(value: .books(.loadingActive(false)))
                )
                
            case let .response(.failure(error)):
                return .merge(
                    .init(value: .loadingActive(false)),
                    .init(value: .books(.loadingActive(false)))
                )

            case let .search(.searchQueryChanged(query)):
                state.booksState.items = []
                state.booksState.currentPage = Calc.defaultOne
                return .concatenate(
                    .init(value: .loadingActive(true)),
                    .init(value: .request)
                )
                
            case .books(.loadMore):
                return .init(value: .request)
                
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

// MARK: - Namespace

extension Main {
    private enum Calc {
        static let defaultOne = 1
        static let countOfItemsPerPage = 100
    }
}
