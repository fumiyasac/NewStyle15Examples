//
//  MainNews.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/07/12.
//

import Foundation

struct MainNews: Hashable, Decodable {

    let id: Int
    let newsType: String
    let dateString: String
    let imageUrl: String
    let title: String
    let description: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case newsType = "news_type"
        case dateString = "date_string"
        case imageUrl = "image_url"
        case title
        case description
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.newsType = try container.decode(String.self, forKey: .newsType)
        self.dateString = try container.decode(String.self, forKey: .dateString)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MainNews, rhs: MainNews) -> Bool {
        return lhs.id == rhs.id
    }
}
