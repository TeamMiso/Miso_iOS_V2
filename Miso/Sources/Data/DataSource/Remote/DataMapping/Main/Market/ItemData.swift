import Foundation

var itemList: [itemListResponse] = []

struct itemListResponse: Codable {
    let id: Int
    let price: Int
    let amount: Int
    let name: String
    let imageUrl: String
}

struct itemDetailListResponse: Codable {
    let id: Int
    let price: Int
    let amount: Int
    let name: String
    let imageUrl: String
}
