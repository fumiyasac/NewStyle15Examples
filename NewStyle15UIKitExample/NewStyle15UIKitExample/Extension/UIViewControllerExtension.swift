//
//  UIViewControllerExtension.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/26.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // この画面のナビゲーションバーを設定するメソッド
    public func setupNavigationBarTitle(_ title: String) {

        // NavigationControllerのデザイン調整を行う
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.black

        // NavigationBarをタイトル配色を決定する
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title

        // ラージタイトルの表示設定に関する設定やデザイン調整を行う
        // 下記「stackoverflow」に掲載されていたコードを参考に実装しています。
        // http://bit.ly/2TXCbd7
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController.navigationBar.prefersLargeTitles = true

        // MEMO: iOS13以降ではラージタイトル表示時の属性テキストの設定方法が若干変わる点に注意する
        // https://qiita.com/MilanistaDev/items/6181495e8504612ec053
        var largeAttributes: [NSAttributedString.Key : Any] = [:]
        largeAttributes[NSAttributedString.Key.font] = UIFont(name: "HiraKakuProN-W6", size: 26.0)
        largeAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.white
            appearance.largeTitleTextAttributes = largeAttributes
            appearance.titleTextAttributes = attributes
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.standardAppearance = appearance
        } else {
            navigationController.navigationBar.largeTitleTextAttributes = largeAttributes
        }
    }

    // 戻るボタンの「戻る」テキストを削除した状態にするメソッド
    public func removeBackButtonText() {

        // NavigationBarをタイトル配色を決定する
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.tintColor = UIColor.black

        // 戻るボタンの文言を消す
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}
