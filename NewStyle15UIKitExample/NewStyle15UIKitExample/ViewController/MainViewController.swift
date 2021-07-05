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

        // 
        async {
            let samples = try? await ApiClientManager.shared.getSamples()
            print(samples)
        }
    }
}
