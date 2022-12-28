//
//  ErrorUtility.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

class ErrorUtility {
    public static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
        return lhs.reflectedString == rhs.reflectedString
    }
}

public extension Error {
    var reflectedString: String {
        return String(reflecting: self)
    }
    
    func isEqual(to: Self) -> Bool {
        return reflectedString == to.reflectedString
    }
}

enum ProviderError: Error, Equatable {
    static func == (lhs: ProviderError, rhs: ProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let lhsError), .network(let rhsError)):
            return ErrorUtility.areEqual(lhsError, rhsError)
        case (.decoding(let lhsError), .decoding(let rhsError)):
            return ErrorUtility.areEqual(lhsError, rhsError)
        case (.encoding(let lhsError), .encoding(let rhsError)):
            return ErrorUtility.areEqual(lhsError, rhsError)
        case (.error(let lhsError), .error(let rhsError)):
            return ErrorUtility.areEqual(lhsError, rhsError)
        default: return false
        }
    }
    
    case network(error: Error)
    case decoding(error: Error)
    case encoding(error: Error)
    case error(error: Error)
    case notFound
}
