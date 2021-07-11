//
//  MainPhotoAPIResponse.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/07/07.
//

import Foundation

// MEMO: アイテム一覧表示用のAPIレスポンス定義

struct MainPhotoAPIResponse: Decodable {

    let page: Int
    let photos: [MainPhoto]
    let hasNextPage: Bool

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case page
        case photos
        case hasNextPage = "has_next_page"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.photos = try container.decode([MainPhoto].self, forKey: .photos)
        self.hasNextPage = try container.decode(Bool.self, forKey: .hasNextPage)
    }
}
