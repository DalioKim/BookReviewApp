//
//  MainCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import Foundation

// MARK: - Namespace

fileprivate enum Calc {
    static let defaultZero = 0
    static let defaultOne = 1
    static let countOfItemsPerPage = 100
}

// MARK: - State

struct MainState: Equatable {
    var books = IdentifiedArrayOf<DetailState>()
    var query = ""
    var currentPage = Calc.defaultOne
    var searchResultsCount = Calc.defaultZero
    
    fileprivate func isLastItem(_ item: UUID) -> Bool {
        let itemIndex = books.firstIndex(where: { $0.id == item })
        return itemIndex == books.endIndex - Calc.defaultOne
    }
    
    fileprivate var isMoreSearchResults: Bool {
        return searchResultsCount > currentPage * Calc.countOfItemsPerPage
    }
}

// MARK: - Action

enum MainAction: Equatable {
    case searchQueryChanged(String)
    case retrieveNextPageIfNeeded(currentItem: UUID)
    case booksResponse(Result<BookResponse, ServiceError>)
    case moveDetail(id: DetailState.ID, action: DetailAction)
}

// MARK: - Environment

struct MainEnvironment {
    var booksClient: BookClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer

let MainReducer: Reducer<MainState, MainAction, MainEnvironment> = .combine(
    .init { state, action, environment in
        struct BooksCancelId: Hashable {}
        
        switch action {
        case let .searchQueryChanged(query):
            state.query = query
            state.currentPage = Calc.defaultOne
            
            return environment.booksClient
                .search(.title(query: state.query, pageNum: state.currentPage))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(MainAction.booksResponse)
                .cancellable(id: BooksCancelId())
            
        case let .retrieveNextPageIfNeeded(uuid):
            guard state.isLastItem(uuid),
                  state.isMoreSearchResults else {
                      return .none
                  }
            
            state.currentPage += Calc.defaultOne
            
            return environment.booksClient
                .search(.title(query: state.query, pageNum: state.currentPage))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(MainAction.booksResponse)
                .cancellable(id: BooksCancelId())
            
        case let .booksResponse(.success(result)):
            state.searchResultsCount = result.searchResultsCount
            state.books += result.items.map { DetailState(book: $0) }
            return .none
            
        case let .booksResponse(.failure(error)):
            return .none
            
        case .moveDetail:
            return .none
        }
    }
)
