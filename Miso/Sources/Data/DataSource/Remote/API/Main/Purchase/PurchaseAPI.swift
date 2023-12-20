import Foundation
import Moya

enum PurchaseAPI {
    case puchaseHistory(accessToken: String)
    case buyItem(id: Int, accessToken: String)
}
extension PurchaseAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/purchase")!
    }
    
    var path: String {
        switch self {
        case .puchaseHistory:
            return ""
        case let .buyItem(id, accessToken):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .puchaseHistory:
            return .get
        case .buyItem:
            return .post
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .puchaseHistory(accessToken):
            return ["Authorization": accessToken]
        case let .buyItem(id, accessToken):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

