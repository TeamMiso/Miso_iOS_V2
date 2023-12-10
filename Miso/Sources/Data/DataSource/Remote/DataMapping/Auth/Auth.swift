import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let accessExp: String
    let refreshExp: String
}

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiredAt: String
}
