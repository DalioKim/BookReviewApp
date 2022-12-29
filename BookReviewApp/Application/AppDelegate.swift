//
//  AppDelegate.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIImageView.initializeImageCache()
        return true
    }
}
