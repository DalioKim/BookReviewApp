//
//  BooksClient.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import Foundation

struct BooksClient {
    var search: (_ query: String, _ pageNum: Int) -> Effect<[Book], Error>
}

// MARK: - Live

extension BooksClient {
    static let live = BooksClient(
        search: { query, pageNum in
            var urlComponents = URLComponents(string: AppConfiguration.apiBaseURL) ?? URLComponents()
            
            let titleQuery = URLQueryItem(name: "title", value: query)
            urlComponents.queryItems?.append(titleQuery)
            let pageNumQuery = URLQueryItem(name: "page", value: String(pageNum))
            urlComponents.queryItems?.append(pageNumQuery)
            var request = URLRequest(url: urlComponents.url ?? URL(fileURLWithPath: ""))
            request.httpMethod = "GET"
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: BookResponse.self, decoder: JSONDecoder())
                .map { $0.items }
                .eraseToAnyPublisher()
                .eraseToEffect()
        }
    )
}
