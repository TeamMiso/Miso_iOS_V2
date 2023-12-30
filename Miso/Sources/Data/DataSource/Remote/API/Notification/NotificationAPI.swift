import Foundation
import Moya

enum NotificationAPI {
    case saveDeviceToken(accessToken: String, deviceToken: String)
    case getItemDetailList(accessToken: String, id: String)
}
extension NotificationAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/notification")!
    }
    
    var path: String {
        switch self {
        case let .saveDeviceToken( _, deviceToken):
            return "/save/\(deviceToken)"
        case let .getItemDetailList( _, id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .saveDeviceToken:
            return .post
        case .getItemDetailList:
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
        case let .saveDeviceToken(accessToken, _):
            return ["Authorization": accessToken]
        case let .getItemDetailList(accessToken, _):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

