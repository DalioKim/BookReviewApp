//
//  MainCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import Foundation

struct MainState: Equatable {
    var books = [Book]()
    var query = ""
    var currentPage = 1
}

enum MainAction {
    case searchQueryChanged(String)
    case booksResponse(Result<[Book], Error>)
}

struct MainEnvironment {
    var booksClient: BooksClient
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
            
            return  environment.booksClient
                .search(state.query, state.currentPage)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(MainAction.booksResponse)
                .cancellable(id: BooksCancelId())
            
        case .booksResponse(.success(let result)):
            state.books += result
            return .none
            
        case .booksResponse(.failure(let error)):
            return .none
        }
    }
)
