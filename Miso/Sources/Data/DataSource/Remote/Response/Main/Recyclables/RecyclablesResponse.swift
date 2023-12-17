import Foundation

struct DetailRecyclablesListResponse: Decodable {
    let id: Int
    let title: String
    let subTitle: String
    let recycleMethod: String
    let recycleTip: String
    let recycleCaution: String
    let imageUrl: String
    let recyclablesType: String
    let recycleMark: String
}

struct SearchRecyclablesListResponse: Decodable {
    let title: String
    let imageUrl: String
    let recycleMethod: String
    let recyclablesType: String
}

struct AllRecyclablesListResponse: Decodable {
    let recyclablesList: [RecyclablesList]
    
    struct RecyclablesList: Decodable {
        let title: String
        let imageUrl: String
        let recyclablesType: String
    }
}

struct UploadRecyclablesListResponse: Decodable {
    let recyclablesList: [RecyclablesList]
    
    struct RecyclablesList: Decodable {
        let id: Int
        let title: String
        let subTitle: String
        let recycleMethod: String
        let recycleTip: String
        let recycleCaution: String
        let imageUrl: String
        let recyclablesType: String
        let recycleMark: String
    }
}
