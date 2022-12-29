//
//  SceneDelegate.swift
//  BookReviewApp
//
//  Created by 김동현 on 2022/12/28.
//

import ComposableArchitecture
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainStore = Store<MainState, MainAction>(initialState: MainState(), reducer: MainReducer, environment: MainEnvironment(booksClient: .live, mainQueue: DispatchQueue.main.eraseToAnyScheduler()))
        let window = UIWindow(windowScene: windowScene)
        
        window.backgroundColor = .white
        window.rootViewController = UINavigationController(rootViewController: MainViewController(store: mainStore))
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
