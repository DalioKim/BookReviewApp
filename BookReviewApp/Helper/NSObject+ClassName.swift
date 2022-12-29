//
//  NSObject+ClassName.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/29.
//

import Foundation

@objc
extension NSObject {
    class var className: String {
        String(describing: self)
    }
}
