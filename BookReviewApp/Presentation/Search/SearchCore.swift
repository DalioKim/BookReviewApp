//
//  SearchCore.swift
//  BookReviewApp
//
//  Created by 김동현 on 2023/01/06.
//

import ComposableArchitecture
import Foundation

struct Search {
    struct State: Equatable {
        var option = SearchOption.title
    }
    
    enum Action {
        case searchOptionChanged(SearchOption)
        case searchQueryChanged(String)
    }
    
    static let reducer =
    Reducer<Search.State, Search.Action, Void> { state, action, _ in
        switch action {
        case let .searchOptionChanged(option):
            state.option = option
            return .none
        default:
            return .none
        }
    }
}
