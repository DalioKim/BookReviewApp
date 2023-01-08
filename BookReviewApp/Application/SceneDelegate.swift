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
        
        let window = UIWindow(windowScene: windowScene)
        let mainStore = Store<Main.State, Main.Action>(
            initialState: Main.State(),
            reducer: Main.reducer,
            environment: Main.Environment(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                                          booksClient: .live)
        )

        window.backgroundColor = .white
        window.rootViewController = UINavigationController(rootViewController: MainViewController(with: mainStore))
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
