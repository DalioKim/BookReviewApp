//
//  DetailCore.swift
//  BookReviewApp
//
//  Created by κΉλν on 2022/12/29.
//

import ComposableArchitecture
import Foundation

struct DetailState: Equatable, Identifiable {
    let id = UUID()
    var book: Book
}

enum DetailAction: Equatable {
    case view(UUID)
}
