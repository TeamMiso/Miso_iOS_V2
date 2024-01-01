import Foundation
import Moya

enum NotificationAPI {
    case sendDeviceToken(accessToken: String, deviceToken: String)
    case getMyInquiryAnswer(accessToken: String, id: Int)
}
extension NotificationAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/notification")!
    }
    
    var path: String {
        switch self {
        case let .sendDeviceToken( _, deviceToken):
            return "/save/\(deviceToken)"
        case let .getMyInquiryAnswer( _, id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendDeviceToken:
            return .post
        case .getMyInquiryAnswer:
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
        case let .sendDeviceToken(accessToken, _):
            return ["Authorization": accessToken]
        case let .getMyInquiryAnswer(accessToken, _):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

