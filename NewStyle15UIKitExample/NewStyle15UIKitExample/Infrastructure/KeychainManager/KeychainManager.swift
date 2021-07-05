//
//  KeychainManager.swift
//  NewStyle15UIKitExample
//
//  Created by 酒井文也 on 2021/07/06.
//

import Foundation
import KeychainAccess

protocol KeychainManagerProtocol {

    // 新しく取得したJWTの保存処理
    func saveJsonAccessToken(_ token: String)

    // 既に登録されているJWTの削除処理
    func deleteJsonAccessToken()

    // 既に登録されているJWTの存在確認処理
    func existsJsonAccessToken() -> Bool
}

class KeychainManager: KeychainManagerProtocol {

    // MARK: - Singleton Instance

    static let shared = KeychainManager()

    // MARK: - Properies

    // keychainAccessのKey名
    private let keyName = "jsonAccessToken"
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    // JWTのprefix名
    private let jwtTokenPrefix = "Bearer "

    // MARK: - Function

    // API管理クラスで利用するJWT文字列を取得する
    func getAuthenticationHeader() -> String {
        if existsJsonAccessToken() {
            return jwtTokenPrefix + keychain[string: keyName]!
        } else {
            return ""
        }
    }

    // API管理クラスで利用するJWT文字列をキーチェーンへ保存する
    func saveJsonAccessToken(_ token: String) {
        keychain[string: keyName] = token
    }

    // API管理クラスで利用するJWT文字列をキーチェーンから削除する
    func deleteJsonAccessToken() {
        keychain[string: keyName] = nil
    }

    // JWT文字列がキーチェーンに存在するかを判定する
    func existsJsonAccessToken() -> Bool {
        return (keychain[string: keyName] != nil)
    }
}
