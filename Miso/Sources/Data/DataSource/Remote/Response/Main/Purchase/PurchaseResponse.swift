import Foundation

struct PurchaseHistoryResponse: Decodable {
    
    let purchaseList: [PurchaseList]
    
    struct PurchaseList: Decodable {
        let id: Int
        let price: Int
        let name: String
        let imageUrl: String
        let createdDate: String
    }
}
