//
//  BooksCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2023/01/06.
//

import ComposableArchitecture
import Foundation

struct Books {
    private enum Calc {
       static let defaultOne = 1
       static let countOfItemsPerPage = 100
   }
    
    struct State : Equatable {
        var query = ""
        var books = [Book]()
        var isLoadingPage = false
        var currentPage = 1
        var pageSize = 1
        
        fileprivate func isLastItem(_ idx: Int) -> Bool {
            return idx == books.count - Calc.defaultOne
        }
        
        fileprivate var isMoreBooks: Bool {
            return pageSize > currentPage
        }
    }
    
    enum Action {
        case request(String)
        case response(Result<BookResponse, ServiceError>)
        case nextPage(idx: Int)
        case loadingActive(Bool)
        case detail(with: Book)
    }
    
    struct Environment {
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var booksClient: BookClient
    }
    
    static let reducer =
    Reducer<Books.State, Books.Action, Books.Environment> { state, action, environment in
        struct BooksCancelId: Hashable {}
        
        switch action {
        case let .request(query):
            state.books = []
            state.query = query
            state.currentPage = 1
            
            return environment.booksClient
                .search(.title(query: state.query, pageNum: state.currentPage))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Books.Action.response)
                .cancellable(id: BooksCancelId())
            
        case let .nextPage(idx):
            guard state.isLastItem(idx), state.isMoreBooks else {
                return .none
            }
            
            state.currentPage += Calc.defaultOne
            return .concatenate(
                .init(value: .loadingActive(true)),
                environment.booksClient
                    .search(.title(query: state.query, pageNum: state.currentPage))
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Books.Action.response)
                    .cancellable(id: BooksCancelId())
            )
            
        case let .response(.success(result)):
            state.pageSize = result.searchResultsCount / Calc.countOfItemsPerPage
            state.books += result.items
            return .init(value: .loadingActive(false))
            
        case let .response(.failure(error)):
            return .init(value: .loadingActive(false))
            
        case let .loadingActive(isLoading):
            state.isLoadingPage = isLoading
            return .none
            
        default:
            return .none
        }
    }
}
