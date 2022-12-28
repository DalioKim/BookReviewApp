//
//  BookResponse.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import Foundation

struct BookResponse: Codable, Equatable {
  var items: [Book]
    enum Keys: String, CodingKey {
        case items = "docs"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        items = try container.decodeIfPresent([Book].self, forKey: .items) ?? []
    }
}

// MARK: - Book

struct Book: Codable, Equatable {
    var thumbnailIdx: Int?
    var title: String
    
    enum Keys: String, CodingKey {
        case thumbnailIdx = "cover_i"
        case title = "title"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        thumbnailIdx = try container.decodeIfPresent(Int.self, forKey: .thumbnailIdx)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
}
