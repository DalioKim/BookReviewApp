//
//  AppDelegate.swift
//  BookReviewApp
//
//  Created by κΉλν on 2022/12/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIImageView.initializeImageCache()
        return true
    }
}
