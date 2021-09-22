//
//  AppDelegate.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MEMO: iOS15に関する配色に関する調整対応
        setupTabBarAppearance()

        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Private Function

    private func setupTabBarAppearance() {

        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()

            // UITabBarItemの選択時と非選択時の文字色の装飾設定
            tabBarItemAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
                
            ]
            tabBarItemAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.darkGray
            ]
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
