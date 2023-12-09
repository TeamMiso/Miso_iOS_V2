import Foundation

extension Bundle {
    var baseURL: String {
        guard let file = self.path(forResource: "BaseURL", ofType: "plist") else {
            fatalError("BaseURL.plist 파일을 찾을 수 없습니다.")
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("BaseURL.plist 파일 형식 에러")
        }
        
        if let key = resource["Base-API-KEY"] as? String {
            return key
        } else {
            fatalError("BaseURL.plist 파일에서 'Base-API-KEY' 값을 찾을 수 없습니다.")
        }
    }
}
