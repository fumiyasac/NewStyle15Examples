//
//  FeaturedContents.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/07/07.
//

import Foundation

struct FeaturedContents: Hashable, Decodable {

    let id: Int
    let authorName: String
    let dateString: String
    let imageUrl: String
    let title: String
    let mainText: String
    let subText: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case authorName = "author_name"
        case dateString = "date_string"
        case imageUrl = "image_url"
        case title
        case mainText = "main_text"
        case subText = "sub_text"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.authorName = try container.decode(String.self, forKey: .authorName)
        self.dateString = try container.decode(String.self, forKey: .dateString)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.title = try container.decode(String.self, forKey: .title)
        self.mainText = try container.decode(String.self, forKey: .mainText)
        self.subText = try container.decode(String.self, forKey: .subText)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeaturedContents, rhs: FeaturedContents) -> Bool {
        return lhs.id == rhs.id
    }
}
