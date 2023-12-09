import Foundation

final class KeychainLocal {
    static let shared = KeychainLocal()
    private let keychain = Keychain()
    private init() {}

    func saveAccessToken(_ token: String) {
        keychain.save(type: .accessToken, value: token)
    }

    func fetchAccessToken() throws -> String {
        return try keychain.load(type: .accessToken)
    }

    func deleteAccessToken() {
        keychain.delete(type: .accessToken)
    }

    func saveRefreshToken(_ token: String) {
        keychain.save(type: .refreshToken, value: token)
    }

    func fetchRefreshToken() throws -> String {
        return try keychain.load(type: .refreshToken)
    }

    func deleteRefreshToken() {
        keychain.delete(type: .refreshToken)
    }

    func saveAccessExp(_ date: String) {
        keychain.save(type: .accessExpiredAt, value: date)
    }

    func fetchAccessExp() throws -> String {
        return try keychain.load(type: .accessExpiredAt)
    }

    func deleteAccessExp() {
        keychain.delete(type: .accessExpiredAt)
    }

    func saveRefreshExp(_ date: String) {
        keychain.save(type: .refreshExpiredAt, value: date)
    }

    func fetchRefreshExp() throws -> String {
        return try keychain.load(type: .refreshExpiredAt)
    }

    func deleteRefreshExp() {
        keychain.delete(type: .refreshExpiredAt)
    }
}

