import Foundation
import Moya

enum RecyclablesAPI {
    case getDetailRecyclables(accessToken: String)
    case searchRecyclables(accessToken: String)
    case getAllRecyclables(accessToken: String)
    case uploadImage(accessToken: String, image: Data)
}

extension RecyclablesAPI: TargetType {
        
    var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/recyclables")!
    }
    
    var path: String {
        switch self {
        case .getDetailRecyclables:
            return ""
        case .searchRecyclables:
            return "/search"
        case .getAllRecyclables:
            return "/all"
        case .uploadImage:
            return "/process_image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDetailRecyclables, .searchRecyclables, .getAllRecyclables:
            return .get
        case .uploadImage:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getDetailRecyclables, .searchRecyclables, .getAllRecyclables:
            return "@@".data(using: .utf8)!
        case .uploadImage:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case let .uploadImage(acccessToken, image):
            let multipartFormData = MultipartFormData(
                provider: .data(image),
                name: "recyclables",
                fileName: "recyclable.jpg",
                mimeType: "image/jpeg")
            return .uploadMultipart([multipartFormData])
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .uploadImage(accessToken, image):
            return [
                "Authorization": accessToken,
                "Content-Type": "multipart/form-data"
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
