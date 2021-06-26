//
//  NSObjectProtocolExtension.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/06/26.
//

import Foundation
import UIKit

// NSObjectProtocolの拡張
extension NSObjectProtocol {

    // クラス名を返す変数"className"を返す
    static var className: String {
        return String(describing: self)
    }
}
