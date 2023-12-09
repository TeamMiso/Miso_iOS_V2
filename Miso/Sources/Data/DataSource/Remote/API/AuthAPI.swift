import Foundation
import Moya

enum AuthAPI {
    case signup(email: String, password: String, passwordCheck: String)
    case login(email: String, password: String)
    case refresh(refreshToken: String)
    case logout(accessToken: String)
    case certificationNumber(randomKey: String)
}
extension AuthAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/signIn"
        case .signup, .logout, .refresh:
            return "/auth"
        case .certificationNumber:
            return "/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signup, .certificationNumber:
            return .post
        case .refresh:
            return .patch
        case .logout:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
            
        case let .signup(email, password, passwordCheck):
            return .requestParameters(parameters: [
                "email": email,
                "password": password,
                "passwordCheck": passwordCheck
            ], encoding: JSONEncoding.default)
            
        case let .login(email, password):
            return .requestParameters(parameters: [
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default)
            
        case let .certificationNumber(randomKey):
            return .requestParameters(parameters: [
                "randomKey": randomKey,
            ], encoding: JSONEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .logout(accessToken):
            return ["Authorization": accessToken]
        case let .refresh(refreshToken):
            return ["Refresh-Token": "Bearer " + "\(refreshToken)"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
