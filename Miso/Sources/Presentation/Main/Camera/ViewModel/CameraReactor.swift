import Foundation
import UIKit
import RxFlow
import Moya
import RxSwift
import RxCocoa

class CameraVM: BaseVM, Stepper{
    
    let recycleProvider = MoyaProvider<RecyclablesAPI>(plugins: [NetworkLoggerPlugin()])
    
    var recyclablesListData: recyclablesListResponse!
    
    struct Input {
        let uploadImage: Observable<Void>
    }
    
    struct Output {
        
    }
    
    private func pushProfileVC() {
        self.steps.accept(MisoStep.searchTabbarIsRequired)
    }
}

extension CameraVM {
    func uploadImage(image: Data) {
        recycleProvider.request(.uploadImage(accessToken: accessToken, image: image)) { response in
            switch response {
            case .success(let result):
                do {
                    self.recyclablesListData = try result.map(recyclablesListResponse.self)
                } catch(let err) {
                    print(String(describing: err))
                }
                
                let statusCode = result.statusCode
                
                switch statusCode{
                case 201:
                    print("Camera 성공")
                case 401:
                    print("토큰이 유효하지 않습니다.")
                case 410, 413:
                    print("contentType 오류")
                case 500:
                    print("서버 오류")
                default:
                    print(statusCode)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
