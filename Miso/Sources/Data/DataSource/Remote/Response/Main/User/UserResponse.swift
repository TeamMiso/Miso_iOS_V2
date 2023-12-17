import Foundation

struct getUserInfoResponse: Codable {
    let id: UUID
    let email: String
    let password: String
    let point: Int
    let role: String
}

struct getUserPointRespone: Codable {
    let point: Int
}
