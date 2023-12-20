import Foundation
import Moya

enum ItemAPI {
    case getItemList(accessToken: String)
    case getItemDetailList(id: String, accessToken: String)
}
extension ItemAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/item")!
    }
    
    var path: String {
        switch self {
        case .getItemList:
            return ""
        case let .getItemDetailList(id, accessToken):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getItemList, .getItemDetailList:
            return .get
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
        case let .getItemList(accessToken):
            return ["Authorization": accessToken]
        case let .getItemDetailList(id, accessToken):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
