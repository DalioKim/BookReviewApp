//
//  AppConfiguration.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import Foundation

final class AppConfiguration {
    static var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    static func imagesBaseURL(with idx: Int) -> String {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL + "\(idx)-S.jpg"
    }
}
