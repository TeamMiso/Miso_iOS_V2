import Foundation
import Moya
import UIKit

enum RecyclablesAPI {
    case getDetailRecyclables(accessToken: String, recycleType: String)
    case searchRecyclables(accessToken: String, searchText: String)
    case getAllRecyclables(accessToken: String)
    case uploadImage(accessToken: String, image: Data, originalImage: UIImage)
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
            return "/process"
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
        case let .getDetailRecyclables(accessToken, recycleType):
            var param: [String: String] = [
                "recyclablesType": recycleType
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case let .searchRecyclables(accessToken, searchText):
            var param: [String: String] = [
                "searchValue": searchText
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case let .uploadImage(acccessToken, image, originalImage):
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
        case let .getDetailRecyclables(accessToken, searchText):
            return ["Authorization": accessToken]
        case let .searchRecyclables(accessToken, searchText):
            return ["Authorization": accessToken]
        case let .uploadImage(accessToken, image, originalImage):
            return [
                "Authorization": accessToken,
                "Content-Type": "multipart/form-data"
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
