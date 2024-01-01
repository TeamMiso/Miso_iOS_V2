import Foundation

struct MyInquiryListResponse: Decodable {
    
    let inquiryList: [MyInquiryList]
    
    struct MyInquiryList: Decodable {
        let id: Int
        let inquiryDate: String
        let title: String
        let imageUrl: String
        let inquiryStatus: String
    }
}

struct DetailInquiryResponse: Decodable {
    let id: Int
    let inquiryDate: String
    let title: String
    let content: String
    let imageUrl: String
    let inquiryStatus: String
}
