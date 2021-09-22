//
//  GlobalTabBarController.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/26.
//

import UIKit

final class GlobalTabBarController: UITabBarController {

    // MARK: - Enum

    enum GlobalTabBar: CaseIterable {
        case main
        case featured
        case setting

        // MARK: - Function

        // 配置するタイトルを取得する
        func getTabBarTitle() -> String {
            switch self {
            case .main:
                return "Main Contents"
            case .featured:
                return "Featured Contents"
            case .setting:
                return "User Settings"
            }
        }

        // 配置するSF Symbolsのアイコン名前を取得する
        func getTabBarSymbolName() -> String {
            switch self {
            case .main:
                return "text.below.photo.fill"
            case .featured:
                return "rectangle.3.offgrid.bubble.left.fill"
            case .setting:
                return "list.bullet.circle.fill"
            }
        }
    }

    // MARK: - Properties

    private let itemSize = CGSize(width: 28.0, height: 28.0)
    private let normalColor: UIColor = UIColor.lightGray
    private let selectedColor: UIColor = UIColor.darkGray
    private let tabBarItemFont = UIFont(name: "HelveticaNeue-Medium", size: 10)!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGlobalTabBarController()
    }

    // MARK: - Private Function

    // UITabBarControllerの初期設定に関する調整
    private func setupGlobalTabBarController() {

        // MEMO: UITabBarControllerDelegateの宣言
        self.delegate = self
        
        // MEMO: 各画面の土台となるUINavigationControllerをセットする
        let mainNavigationController = UINavigationController()
        let featuredNavigationController = UINavigationController()
        let questionNavigationController = UINavigationController()

        self.viewControllers = [
            mainNavigationController,
            featuredNavigationController,
            questionNavigationController
        ]
        mainNavigationController.pushViewController(
            UIStoryboard(name: "MainViewController", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )
        featuredNavigationController.pushViewController(
            UIStoryboard(name: "FeaturedViewController", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )
        questionNavigationController.pushViewController(
            UIStoryboard(name: "QuestionViewController", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )

        // MEMO: タブの選択時・非選択時の色とアイコンのサイズを決める
        // UITabBarItem用のAttributeを決める
        let normalAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: normalColor
        ]
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: selectedColor
        ]

        let _ = GlobalTabBarController.GlobalTabBar.allCases.enumerated().map { (index, tabBarItem) in

            // 該当ViewControllerのタイトルの設定
            self.viewControllers?[index].title = tabBarItem.getTabBarTitle()

            // 該当ViewControllerのUITabBar要素の設定
            self.viewControllers?[index].tabBarItem.tag = index
            // MEMO: iOS15以降ではこちらの方法では適用されない点に注意
            if #available(iOS 15, *) {
                // Do Nothing.
            } else {
                self.viewControllers?[index].tabBarItem.setTitleTextAttributes(normalAttributes, for: [])
                self.viewControllers?[index].tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
            }
            self.viewControllers?[index].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 0.0)
            self.viewControllers?[index].tabBarItem.image
                = UIImage(
                    systemName: tabBarItem.getTabBarSymbolName(),
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
                    )!.withTintColor(normalColor, renderingMode: .alwaysOriginal)
            self.viewControllers?[index].tabBarItem.selectedImage
                = UIImage(
                    systemName: tabBarItem.getTabBarSymbolName(),
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
                    )!.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
        }
    }

    private func setupTabBarAppearance() {

        // iOS15以降でiOS14以前と同じUINavigationBarの配色指定方法が変化する点に注意する
        // https://shtnkgm.com/blog/2021-08-18-ios15.html

        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()

            // UITabBarItemの選択時と非選択時の文字色の装飾設定
            tabBarItemAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
                
            ]
            tabBarItemAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor(code: "#cda966")
            ]
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension GlobalTabBarController: UITabBarControllerDelegate {}
