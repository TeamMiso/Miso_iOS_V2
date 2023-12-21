import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class AuthReactor: Reactor, Stepper {
    
    // MARK: - Properties
    var initialState: State
    var steps: PublishRelay<Step> = .init()
    let authProvider = MoyaProvider<AuthAPI>(plugins: [NetworkLoggerPlugin()])
    var authData: AuthResponse!
    let keychain = Keychain()

    
    // MARK: - Reactor
    enum Action {
        case loginIsCompleted(email: String, password: String)
        case signupIsRequired
        case signupIsCompleted(email: String, password: String, passwordCheck: String)
        case certificationIsCompleted(randomKey: String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension AuthReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loginIsCompleted(email, password):
            return loginIsCompleted(email: email, password: password)
        case let .signupIsRequired:
            return signupIsRequired()
        case let .signupIsCompleted(email, password, passwordCheck):
            return signupIsCompleted(email: email, password: password, passwordCheck: passwordCheck)
        case let .certificationIsCompleted(randomKey):
            return certificationIsCompleted(randomkey: randomKey)
        }
    }
}

// MARK: - Method
private extension AuthReactor {
    
    func signupIsRequired() -> Observable<Mutation> {
        self.steps.accept(MisoStep.signupVCIsRequired)
        return .empty()
    }
    
    private func loginIsCompleted(email: String, password: String) -> Observable<Mutation>  {
        authProvider.request(.login(email: email, password: password)) { response in
            switch response {
            case .success(let result):
                do {
                    self.authData = try result.map(AuthResponse.self)
                } catch(let err) {
                    print(String(describing: err))
                }
                
                let statusCode = result.statusCode
                
                switch statusCode{
                case 200:
                    print("AuthReactor: 성공")
                    KeychainLocal.shared.saveAccessToken(self.authData.accessToken)
                    KeychainLocal.shared.saveRefreshToken(self.authData.refreshToken)
                    KeychainLocal.shared.saveAccessExp(self.authData.accessExp)
                    KeychainLocal.shared.saveRefreshExp(self.authData.refreshExp)
                    self.steps.accept(MisoStep.tabBarIsRequired)
                case 400:
                    print("비밀번호가 일치하지 않습니다.")
                case 403:
                    print("이메일이 인증되지 않았습니다.")
                case 404:
                    print("사용자를 찾을 수 없습니다.")
                case 500:
                    print("서버 오류")
                default:
                    print(statusCode)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
        return .empty()
    }
    
    private func signupIsCompleted(email: String, password: String, passwordCheck: String) -> Observable<Mutation> {
        
        authProvider.request(.signup(email: email, password: password, passwordCheck: passwordCheck)) { response in
            
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                switch statusCode{
                case 201:
                    self.steps.accept(MisoStep.certificationVCIsRequied)
                    print("성공")
                case 400:
                    print("비밀번호가 재확인 비밀번호와 일치하지 않습니다")
                case 409:
                    print("이메일이 이미 사용중입니다")
                case 500:
                    print("서버 에러")
                default:
                    print(statusCode)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
        return .empty()
    }
    
    private func certificationIsCompleted(randomkey: String) -> Observable<Mutation> {
        
        authProvider.request(.certificationNumber(randomKey: randomkey)) { response in
            
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                switch statusCode{
                case 200:
                    self.steps.accept(MisoStep.loginVCIsRequired)
                case 401:
                    print("인증번호가 일치하지 않습니다")
                default:
                    print(statusCode)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
        return .empty()
    }
}
