//
//  MainCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import Foundation

struct MainState: Equatable {
    var books = IdentifiedArrayOf<DetailState>()
    var query = ""
    var currentPage = 1
}

enum MainAction: Equatable {
    case searchQueryChanged(String)
    case booksResponse(Result<[Book], ServiceError>)
    case moveDetail(id: DetailState.ID, action: DetailAction)
}

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
            state.currentPage = 1
            
            return environment.booksClient
                .search(.title(query: state.query, pageNum: state.currentPage))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(MainAction.booksResponse)
                .cancellable(id: BooksCancelId())
            
        case let .booksResponse(.success(result)):
            state.books += result.map { DetailState(book: $0) }
            return .none
            
        case let .booksResponse(.failure(error)):
            return .none
            
        case .moveDetail:
            return .none
        }
    }
)
