import Foundation
import UIKit
import Moya

enum InquiryAPI {
    case askInquiry(accessToken: String, image: UIImage, title: String, content: String)
    case getMyInquiryList(accessToken: String)
    case getMyDetailInquiryList(accessToken: String, id: String)
}

extension InquiryAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL + "/inquiry")!
    }
    
    var path: String {
        switch self {
        case .askInquiry:
            return ""  // 여기는 비워두거나 "/ask" 등으로 경로 설정
        case .getMyInquiryList:
            return ""
        case let .getMyDetailInquiryList(_, id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .askInquiry:
            return .post
        case .getMyInquiryList, .getMyDetailInquiryList:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .askInquiry:
            return Data()
        case .getMyInquiryList, .getMyDetailInquiryList:
            return "@@".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case let .askInquiry(accessToken, image, title, content):
            var formData: [MultipartFormData] = []
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                formData.append(MultipartFormData(
                    provider: .data(imageData),
                    name: "file",
                    fileName: "image.jpg",
                    mimeType: "image/jpeg")
                )
            } else {
                
            }
            let inquiryData: [String: String] = [
                "title": title,
                "content": content
            ]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: inquiryData)
            formData.append(MultipartFormData(provider: .data(jsonData), name: "inquiry", mimeType: "application/json"))
          
            return .uploadMultipart(formData)
            
        case .getMyInquiryList, .getMyDetailInquiryList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .askInquiry(accessToken, image, title, content):
            return [
                "Authorization": accessToken,
                "Content-Type": "multipart/form-data"
            ]
        case let .getMyInquiryList(accessToken):
            return ["Authorization": accessToken]
        case let .getMyDetailInquiryList(accessToken, id):
            return ["Authorization": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
