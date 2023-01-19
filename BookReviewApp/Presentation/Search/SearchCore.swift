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
        var word = ""
        var option = Options.Search.title
    }
    
    enum Action {
        case searchOptionChanged(Options.Search)
        case searchQueryChanged(String)
    }
    
    static let reducer =
    Reducer<Search.State, Search.Action, Void> { state, action, _ in
        switch action {
        case let .searchQueryChanged(word):
            state.word = word
            return .none
        case let .searchOptionChanged(option):
            state.option = option
            return .none
        }
    }
}
