//
//  BookResponse.swift
//  BookReviewApp
//
//  Created by κΉλν on 2022/12/28.
//

import Foundation

// MARK: - BookResponse

struct BookResponse: Codable, Equatable {
    var searchResultsCount: Int
    var items: [Book]
    enum Keys: String, CodingKey {
        case searchResultsCount = "numFound"
        case items = "docs"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        searchResultsCount = try container.decodeIfPresent(Int.self, forKey: .searchResultsCount) ?? 0
        items = try container.decodeIfPresent([Book].self, forKey: .items) ?? []
    }
}

// MARK: - Book

struct Book: Codable, Equatable {
    var thumbnailIdx: Int?
    var title: String
    var authorsName: [String]
    
    enum Keys: String, CodingKey {
        case thumbnailIdx = "cover_i"
        case title = "title"
        case authorsName = "author_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        thumbnailIdx = try container.decodeIfPresent(Int.self, forKey: .thumbnailIdx)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        authorsName = try container.decodeIfPresent([String].self, forKey: .authorsName) ?? []
    }
}
