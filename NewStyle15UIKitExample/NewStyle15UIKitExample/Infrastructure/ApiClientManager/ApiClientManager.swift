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
    case error(message: String)
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
    func getMainBanner() async throws -> [MainBanner]
    func getMainNews() async throws -> [MainNews]
    func getMainPhoto(page: Int) async throws -> [MainPhotoAPIResponse]
    func getFeaturedContents() async throws -> [FeaturedContents]
}

final class ApiClientManager {

    // MARK: - Singleton Instance

    static let shared = ApiClientManager()

    private init() {}

    // MARK: - Enum

    private enum EndPoint: String {
        case mainBanners = "main_banners"
        case mainNews = "main_news"
        case mainPhotos = "main_photos"
        case featuredContents = "featured_contents"

        func getBaseUrl() -> String {
            return [host, version, path, self.rawValue].joined(separator: "/")
        }
    }

    // MARK: - Properties

    // MEMO: API Mock ServerへのURLに関する情報
    private static let host = "http://localhost:3000/api/mock"
    private static let version = "v1"
    private static let path = "summer_pieces"

    // MARK: - Function

    func executeAPIRequest<T: Decodable>(endpointUrl: String, withParameters: [String : Any] = [:], httpMethod: HTTPMethod = .GET, responseFormat: T.Type) async throws -> T {

        // MEMO: API通信用のリクエスト作成する（※現状はGET/POSTのみの機構を準備）
        var urlRequest: URLRequest
        switch httpMethod {
        case .GET:
            urlRequest = makeGetRequest(endpointUrl)
        case .POST:
            urlRequest = makePostRequest(endpointUrl, withParameters: withParameters)
        }
        return try await handleAPIRequest(responseType: T.self, urlRequest: urlRequest)
    }

    // MARK: - Private Function

    private func handleAPIRequest<T: Decodable>(responseType: T.Type, urlRequest: URLRequest) async throws -> T {

        // Step1: API Mock Serverへのリクエストを実行する
        let (data, response) = try await executeUrlSession(urlRequest: urlRequest)
        // Step2: 受け取ったResponseを元にハンドリングする
        let _ = try handleErrorByStatusCode(response: response)
        // Step3: JSONをEntityへMappingする
        return try decodeDataToJson(data: data)
    }

    // URLSessionを利用してAPIリクエスト処理を実行する
    // MEMO: URLSession.shared.data(for: urlRequest)はiOS15から利用可能なメソッドである点に注意
    private func executeUrlSession(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw APIError.error(message: "No network connection.")
        }
    }

    // レスポンスで受け取ったStatusCodeを元にエラーか否かをハンドリングする
    private func handleErrorByStatusCode(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.error(message: "No http response.")
        }
        switch httpResponse.statusCode {
        case 200...399:
            break
        case 400:
            throw APIError.error(message: "Bad Request.")
        case 401:
            throw APIError.error(message: "Unauthorized.")
        case 403:
            throw APIError.error(message: "Forbidden.")
        case 404:
            throw APIError.error(message: "Not Found.")
        default:
            throw APIError.error(message: "Unknown.")
        }
    }

    // レスポンスで受け取ったData(JSON)をDecodeしてEntityに変換する
    private func decodeDataToJson<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.error(message: "Failed decode data.")
        }
    }

    // GETリクエストを作成する
    private func makeGetRequest(_ urlString: String) -> URLRequest {

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

    // POSTリクエストを作成する
    private func makePostRequest(_ urlString: String, withParameters: [String : Any] = [:]) -> URLRequest {

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

    func getMainBanner() async throws -> [MainBanner] {
        return try await executeAPIRequest(endpointUrl: EndPoint.mainBanners.getBaseUrl(), httpMethod: HTTPMethod.GET, responseFormat: [MainBanner].self)
    }

    func getMainNews() async throws -> [MainNews] {
        return try await executeAPIRequest(endpointUrl: EndPoint.mainNews.getBaseUrl(), httpMethod: HTTPMethod.GET, responseFormat: [MainNews].self)
    }

    func getMainPhoto(page: Int = 1) async throws -> [MainPhotoAPIResponse] {
        let endpointUrl = EndPoint.mainPhotos.getBaseUrl() + "?page=" + String(page)
        return try await executeAPIRequest(endpointUrl: endpointUrl, httpMethod: HTTPMethod.GET, responseFormat: [MainPhotoAPIResponse].self)
    }

    func getFeaturedContents() async throws -> [FeaturedContents] {
        return try await executeAPIRequest(endpointUrl: EndPoint.featuredContents.getBaseUrl(), httpMethod: HTTPMethod.GET, responseFormat: [FeaturedContents].self)
    }
}
