import UIKit
import Moya
import RxSwift
import RxCocoa

class LoginVM {
    let authProvider = MoyaProvider<AuthAPI>()
    var authData: LoginResponse!
    static var accessToken = ""
}

extension LoginVM {

    func loginCompleted(email: String, password: String) {
        
        authProvider.request(.login(email: email, password: password)) { response in
            
            switch response {
            case .success(let result):
                
                do {
                    self.authData = try result.map(LoginResponse.self)
                    
                } catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                
                switch statusCode{
                case 200..<300:
                    KeychainLocal.shared.saveAccessToken(self.authData.accessToken)
                    KeychainLocal.shared.saveRefreshToken(self.authData.refreshToken)
                    KeychainLocal.shared.saveAccessExp(self.authData.accessExp)
                    KeychainLocal.shared.saveRefreshExp(self.authData.refreshExp)
                case 400:
                    print("Login failed with status code: \(statusCode)")
                default:
                    print(statusCode)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
