//
//  BookClient.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/29.
//

import CombineMoya
import ComposableArchitecture
import Foundation
import Moya

// MARK: - BookClient

struct BookClient {
    var search: (_ option: SearchOption, _ query: String, _ pageNum: Int) -> Effect<BookResponse, ServiceError>
}

extension BookClient {
    static let live = BookClient(
        search: { option, query, pageNum in
            return bookProvider.requestPublisher(.search(option, query: query, pageNum: pageNum))
                .filterSuccessfulStatusCodes()
                .map(BookResponse.self)
                .mapError { ServiceError.moyaError($0) }
                .eraseToEffect()
        }
    )
}

// MARK: - BookProvider

fileprivate let bookProvider = MoyaProvider<BookAPI>()

enum BookAPI {
    case search(_ option: SearchOption, query: String, pageNum: Int)
}

extension BookAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .search:
            guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
                fatalError("ApiBaseURL must not be empty in plist")
            }
            
            return URL(string: apiBaseURL) ?? URL(fileURLWithPath: "")
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search.json"
        }
    }
    
    var task: Task {
        switch self {
        case let .search(.title, query: query, pageNum: pageNum):
            return .requestParameters(parameters: ["title": query, "page": pageNum], encoding: URLEncoding.default)
        case let .search(.author, query: query, pageNum: pageNum):
            return .requestParameters(parameters: ["author": query, "page": pageNum], encoding: URLEncoding.default)
        }
    }
    
    var method: Moya.Method { .get }
    var validationType: ValidationType { .successCodes }
    var headers: [String: String]? { nil }
}
