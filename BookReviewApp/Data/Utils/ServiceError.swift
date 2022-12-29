//
//  ServiceError.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import Foundation
import Moya

// MARK: - ServiceError

enum ServiceError: Error, Equatable {
    case moyaError(MoyaError)
    
    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        return ErrorUtility.areEqual(lhs, rhs)
    }
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .moyaError(let moyaError):
            return moyaError.localizedDescription
        }
    }
}

// MARK: - ErrorUtility

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
