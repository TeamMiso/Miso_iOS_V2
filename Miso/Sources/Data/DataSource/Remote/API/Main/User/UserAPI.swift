import Foundation
import Moya
import UIKit

enum UserAPI {
    case getUserInfo(accessToken: String)
    case getUserPoint(accessToken: String)
    case giveUserPoint(accessToken: String)
}

extension UserAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/user")!
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return ""
        case .getUserPoint:
            return "/point"
        case .giveUserPoint:
            return "/give"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo, .getUserPoint:
            return .get
        case .giveUserPoint:
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
        case let .getUserInfo(accessToken):
            return ["Authorization": accessToken]
        case let .getUserPoint(accessToken):
            return ["Authorization": accessToken]
        case let .giveUserPoint(accessToken):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

