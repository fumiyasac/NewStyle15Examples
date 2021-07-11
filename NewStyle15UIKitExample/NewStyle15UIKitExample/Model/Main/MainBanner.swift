//
//  MainBanner.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/07/07.
//

import Foundation

struct MainBanner: Hashable, Decodable {

    let id: Int
    let title: String
    let category: String
    let summary: String
    let imageUrl: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case title
        case category
        case summary
        case imageUrl = "image_url"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.category = try container.decode(String.self, forKey: .category)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MainBanner, rhs: MainBanner) -> Bool {
        return lhs.id == rhs.id
    }
}
