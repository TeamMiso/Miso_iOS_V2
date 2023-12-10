import Foundation
import Moya
import UIKit
import RxFlow
import RxCocoa

class MisoRefreshToken {
    static let shared = MisoRefreshToken()
    var steps = PublishRelay<Step>()
    var statusCode: Int = 0
    private let authProvider = MoyaProvider<AuthAPI>()
    private var authData: AuthResponse!
    private let keychain = Keychain()
    private lazy var refreshToken: String = {
        do {
            return "Bearer " + (try Keychain.shared.load(type: .refreshToken))
        } catch {
            print("Refresh 토큰을 불러오는 중 에러 발생: \(error)")
            return "Bearer "
        }
    }()

    
    private init() {}

    func tokenReissuance() {
        authProvider.request(.refresh(refreshToken: refreshToken)) { response in
            switch response {
            case .success(let result):
                self.statusCode = result.statusCode
                do {
                    self.authData = try result.map(AuthResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                switch self.statusCode {
                case 200..<300:
                    KeychainLocal.shared.saveAccessToken(self.authData.accessToken)
                    KeychainLocal.shared.saveRefreshToken(self.authData.refreshToken)
                    KeychainLocal.shared.saveAccessExp(self.authData.accessExp)
                    KeychainLocal.shared.saveRefreshExp(self.authData.refreshExp)
                case 400, 401, 404:
                    self.steps.accept(MisoStep.loginVCIsRequired)
                default:
                    self.steps.accept(MisoStep.loginVCIsRequired)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func autoLogin(completion: @escaping () -> Void) {
        authProvider.request(.refresh(refreshToken: refreshToken)) { response in
            switch response {
            case .success(let result):
                self.statusCode = result.statusCode
                completion()
                do {
                    self.authData = try result.map(AuthResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                switch self.statusCode {
                case 200..<300:
                    KeychainLocal.shared.saveAccessToken(self.authData.accessToken)
                    KeychainLocal.shared.saveRefreshToken(self.authData.refreshToken)
                    KeychainLocal.shared.saveAccessExp(self.authData.accessExp)
                    KeychainLocal.shared.saveRefreshExp(self.authData.refreshExp)
                default: break;
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
