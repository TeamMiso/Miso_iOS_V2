import Foundation

struct GetUserInfoResponse: Codable {
    let id: UUID
    let email: String
    let password: String
    let point: Int
    let role: String
}

struct GetUserPointRespone: Codable {
    let point: Int
}
