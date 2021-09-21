//
//  MainViewController.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/24.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Main")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // MEMO: API疎通処理のテスト用に利用する処理
        Task {
            do {
                let mainPhoto = try await ApiClientManager.shared.getMainPhoto(page: 1)
                print(mainPhoto)

//                let mainBanner = try await ApiClientManager.shared.getMainBanner()
//                print(mainBanner)

//                let mainNews = try await ApiClientManager.shared.getMainNews()
//                print(mainNews)

//                let featuredContents = try await ApiClientManager.shared.getFeaturedContents()
//                print(featuredContents)

            } catch APIError.error(let message) {
                print(message)
            }
        }
    }
}
