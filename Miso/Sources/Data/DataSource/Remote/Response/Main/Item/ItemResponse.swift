import Foundation

struct ItemListResponse: Decodable {
    
    let itemList: [ItemList]
    
    struct ItemList: Decodable {
        let id: Int
        let price: Int
        let amount: Int
        let name: String
        let imageUrl: String
    }
}

struct ItemDetailListResponse: Decodable {
    let id: Int
    let price: Int
    let amount: Int
    let name: String
    let content: String
    let imageUrl: String
}
