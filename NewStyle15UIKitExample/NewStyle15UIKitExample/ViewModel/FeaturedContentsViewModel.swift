//
//  FeaturedContentsViewModel.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/07/12.
//

import Foundation
import Combine

// MARK: - Protocol (Inputs)

protocol FeaturedContentsViewModelInputs {
    var initialFetchTrigger: PassthroughSubject<Void, Never> { get }
    var refreshTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - Protocol (Outputs)

protocol FeaturedContentsViewModelOutputs {
    var featuredContents: AnyPublisher<[FeaturedContents], Never> { get }
    var apiRequestState: AnyPublisher<APIRequestState, Never> { get }
}

// MARK: - Protocol (Types)

protocol FeaturedContentsViewModelType {
    var inputs: FeaturedContentsViewModelInputs { get }
    var outputs: FeaturedContentsViewModelOutputs { get }
}

final class FeaturedContentsViewModel: FeaturedContentsViewModelType, FeaturedContentsViewModelInputs, FeaturedContentsViewModelOutputs {

    // MARK: - FeaturedContentsViewModelType

    var inputs: FeaturedContentsViewModelInputs { return self }
    var outputs: FeaturedContentsViewModelOutputs { return self }

    // MARK: - FeaturedContentsViewModelInputs

    let initialFetchTrigger = PassthroughSubject<Void, Never>()
    let refreshTrigger = PassthroughSubject<Void, Never>()

    // MARK: -  FeaturedContentsViewModelOutputs

    var featuredContents: AnyPublisher<[FeaturedContents], Never> {
        return $_featuredContents.eraseToAnyPublisher()
    }
    var apiRequestState: AnyPublisher<APIRequestState, Never> {
        return $_apiRequestState.eraseToAnyPublisher()
    }

    // MARK: - @Published

    // MEMO: ViewModelのOutputへ値を引き渡す際の仲介として利用する
    @Published private var _featuredContents: [FeaturedContents] = []
    @Published private var _apiRequestState: APIRequestState = .none

    // MARK: - Property

    private let apiClientManager: ApiClientManagerProtocol
    private var cancellables: [AnyCancellable] = []

    // MARK: - Initializer

    init(apiClientManager: ApiClientManagerProtocol) {
        self.apiClientManager = apiClientManager

        // MEMO: InputTriggerとAPIリクエストをするための処理を結合する
        // → 実行時はViewController側でviewModel.inputs.fetch●●●Trigger.send()で実行する
        initialFetchTrigger
            .subscribe(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] _ in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.fetchFeaturedContents()
                }
            )
            .store(in: &cancellables)

        // MEMO: 現在まで取得したデータのリフレッシュ処理を伴うAPIリクエスト
        // → 実行時はViewController側でviewModel.inputs.refreshTrigger.send()で実行する
        refreshTrigger
            .subscribe(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] in
                    guard let weakSelf = self else {
                        assertionFailure()
                        return
                    }
                    weakSelf._featuredContents.removeAll()
                    weakSelf.fetchFeaturedContents()
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - deinit

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Privete Function

    private func fetchFeaturedContents() {
        Task { @MainActor [weak self] in
            guard let weakSelf = self else {
               assertionFailure()
               return
            }
            // APIとの通信処理を実行する
            weakSelf._apiRequestState = .requesting
            do {
                let featuredContents = try await ApiClientManager.shared.getFeaturedContents()
                weakSelf._apiRequestState = .success
                weakSelf._featuredContents = featuredContents
                print(featuredContents)
            } catch APIError.error(let message) {
                weakSelf._apiRequestState = .error
                print(message)
            }
        }
    }
}
