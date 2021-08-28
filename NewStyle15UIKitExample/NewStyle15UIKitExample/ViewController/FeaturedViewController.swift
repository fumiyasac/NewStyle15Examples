//
//  FeaturedViewController.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/26.
//

import UIKit
import Combine

final class FeaturedViewController: UIViewController {

    // MARK: - Property

    // UITableViewに設置するRefreshControl
    private let refrashControl = UIRefreshControl()

    // sink(receiveCompletion:receiveValue:)実行時に返されるCancellableの保持用の変数
    private var cancellables: [AnyCancellable] = []

    // MEMO: API経由の非同期通信からデータを取得するためのViewModel
    // 補足: Mockに接続する場合はMockAPIRequestManager.sharedを設定する（実機検証時等の場合）
    private let viewModel: FeaturedContentsViewModel = FeaturedContentsViewModel(apiClientManager: ApiClientManager.shared)

    private var apiRequestState: APIRequestState = .none

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModelOutputs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.initialFetchTrigger.send()
    }
    
    // ViewModelのOutputとこのViewControllerでのUIに関する処理をバインドする
    private func bindToViewModelOutputs() {

        // MEMO: APIへのリクエスト状態に合わせたUI側の表示におけるハンドリングを実行する
        viewModel.outputs.apiRequestState
            .subscribe(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] state in
                    guard let weakSelf = self else {
                        assertionFailure()
                        return
                    }
                    weakSelf.handleRefrashControl(state: state)
                    print(state)
                }
            )
            .store(in: &cancellables)
        viewModel.outputs.featuredContents
            .subscribe(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] featuredContents in
                    guard let _ = self else {
                        assertionFailure()
                        return
                    }
                    print(featuredContents)
                }
            )
            .store(in: &cancellables)
    }

    private func handleRefrashControl(state: APIRequestState) {
        switch state {
        case .requesting:
            refrashControl.beginRefreshing()
        default:
            refrashControl.endRefreshing()
        }
    }
}
