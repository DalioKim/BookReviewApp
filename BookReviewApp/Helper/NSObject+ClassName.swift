//
//  NSObject+ClassName.swift
//  BookReviewApp
//
//  Created by κΉλν on 2022/12/29.
//

import Foundation

@objc
extension NSObject {
    class var className: String {
        String(describing: self)
    }
}
