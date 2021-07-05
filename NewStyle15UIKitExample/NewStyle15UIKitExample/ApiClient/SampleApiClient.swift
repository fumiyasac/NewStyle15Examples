//
//  SampleApiClient.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/27.
//

import Foundation

// MARK: - Protocol

protocol SampleApiClient {}

final class SampleApiClientImpl {

    // MARK: - Enum

    // MEMO: APIリクエストに関するEnum定義
    enum HTTPMethod {
        case GET
        case POST
        case PUT
        case DELETE
    }

    // MEMO: APIエラーメッセージに関するEnum定義
    enum APIError: Error {
        case error(String)
    }

    // MEMO: APIリクエストの状態に関するEnum定義
    enum APIRequestState {
        case none
        case requesting
        case success
        case error
    }

    // MARK: - Properties

    // MEMO: API Mock ServerへのURLに関する情報
    static let host = "http://localhost:3000/api"
    static let version = "v1"

    private let session = URLSession.shared

    // MARK: - Private Function
    
    // API Mock ServerへのGETリクエストを作成する
    private func makeGetRequest(_ urlString: String) -> URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // MEMO: 本来であれば認可用アクセストークンをセットする
        let authraizationHeader = "Bearer xxxxxxxxxx"
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }

    // API Mock ServerへのPOSTリクエストを作成する
    private func makePostRequest(_ urlString: String, withParameters: [String : Any] = [:]) -> URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // MEMO: Dictionaryで取得したリクエストパラメータをJSONに変換している
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: withParameters, options: [])
            urlRequest.httpBody = requestBody
        } catch {
            fatalError("Invalid request body parameters.")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // MEMO: 本来であれば認可用アクセストークンをセットする
        let authraizationHeader = "Bearer xxxxxxxxxx"
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
