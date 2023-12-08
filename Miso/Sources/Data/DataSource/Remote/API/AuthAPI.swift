import Foundation
import Moya

enum AuthServices {
    case signup(email: String, password: String, passwordCheck: String)
    case login(email: String, password: String)
    case refresh(refreshTokenRequest: String)
    case logout(accessToken: String)
    case emailCertificationNumber(certificationNumber: String)
}
extension AuthServices: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/auth")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/signIn"
        case .signup, .logout, .refresh:
            return ""
        case .emailCertificationNumber:
                return "/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signup, .emailCertificationNumber:
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
            
        case let .emailCertificationNumber(certificationNumber):
            return .requestParameters(parameters: [
                "randomKey": certificationNumber,
            ], encoding: JSONEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .logout(let param):
            return ["Authorization": param]
        case .refresh(let param):
            return ["RefreshToken": param]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var jwtTokenType: JWTTokenType? {
        switch self {
        case .refresh:
            return .refreshToken

        case .logout:
            return .accessToken

        default:
            return JWTTokenType.none
        }
    }

}
