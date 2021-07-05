//
//  SampleApiClient.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/27.
//

import Foundation

// MEMO: APIリクエストに関するEnum定義
enum HTTPMethod {
    case GET
    case POST
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

// MARK: - Protocol

protocol ApiClientManagerProtocol {
    func getSamples() async throws -> [Sample]
}

struct Sample: Hashable, Decodable {

    let id: Int

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Sample, rhs: Sample) -> Bool {
        return lhs.id == rhs.id
    }
}

final class ApiClientManager {

    // MARK: - Enum

    private enum EndPoint: String {
        // TODO: 新規に作成するAPIエンドポイントに差し替える
        case samples = "samples"

        func getBaseUrl() -> String {
            return [host, version, path, self.rawValue].joined(separator: "/")
        }
    }
    
    // MARK: - Singleton Instance

    static let shared = ApiClientManager()

    private init() {}

    // MARK: - Properties

    // MEMO: API Mock ServerへのURLに関する情報
    private static let host = "http://localhost:3000/api/mock"
    private static let version = "v1"
    private static let path = "summer_pieces"

    // MARK: - Function

    func executeAPIRequest<T: Decodable>(endpointUrl: String, withParameters: [String : Any] = [:], httpMethod: HTTPMethod = .GET, responseFormat: T.Type) async throws -> T {

        var urlRequest: URLRequest
        switch httpMethod {
        case .GET:
            urlRequest = makeGetRequest(endpointUrl)
        case .POST:
            urlRequest = makePostRequest(endpointUrl, withParameters: withParameters)
        }

        // MEMO: API Mock Serverへのリクエスト処理を実行する
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.error("Invalid status code.")
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.error("Invalid data response.")
        }
    }

    // MARK: - Private Function

    // API Mock ServerへのGETリクエストを作成する
    private func makeGetRequest(_ urlString: String) -> URLRequest {

        // MEMO: URLリクエストの作成
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL strings.")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // MEMO: 本来であれば認可用アクセストークンをセットする
        let authraizationHeader = KeychainManager.shared.getAuthenticationHeader()
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }

    // API Mock ServerへのPOSTリクエストを作成する
    private func makePostRequest(_ urlString: String, withParameters: [String : Any] = [:]) -> URLRequest {

        // MEMO: URLリクエストの作成
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL strings.")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        // MEMO: Dictionaryで取得したリクエストパラメータをJSONに変換する
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: withParameters, options: [])
            urlRequest.httpBody = requestBody
        } catch {
            fatalError("Invalid request body parameters.")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // MEMO: 本来であれば認可用アクセストークンをセットする
        let authraizationHeader = KeychainManager.shared.getAuthenticationHeader()
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

// MARK: - ApiClientManagerProtocol

extension ApiClientManager: ApiClientManagerProtocol {
    func getSamples() async throws -> [Sample] {
        return try await executeAPIRequest(endpointUrl: EndPoint.samples.getBaseUrl(), responseFormat: [Sample].self)
    }
}
