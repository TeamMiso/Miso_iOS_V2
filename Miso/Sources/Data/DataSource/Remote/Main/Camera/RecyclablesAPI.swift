import Foundation
import Moya

enum RecyclablesAPI {
    case itemList(accessToken: String)
    case itemDetailList(id: String, accessToken: String)
}
extension RecyclablesAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .itemList:
            return "/item"
        case let .itemDetailList(id, accessToken):
            return "/item/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .itemList, .itemDetailList:
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
        case let .itemList(accessToken):
            return ["Authorization": accessToken]
        case let .itemDetailList(id, accessToken):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

