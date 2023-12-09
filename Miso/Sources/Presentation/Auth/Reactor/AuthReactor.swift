import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class AuthReactor: Reactor, Stepper{
    // MARK: - Properties
    
    var initialState: State
    var steps: PublishRelay<Step> = .init()
    let authProvider = MoyaProvider<AuthAPI>(plugins: [NetworkLoggerPlugin()])
    
    let keychain = Keychain()

    
    var authData: LoginResponse!

    
    // MARK: - Reactor
    
    enum Action {
        case loginButtonTapped(email: String, password: String)
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
        case let .loginButtonTapped(email, password):
            return loginCompleted(email: email, password: password)
        }
    }
}

// MARK: - Method
private extension AuthReactor {
    
    private func loginCompleted(email: String, password: String) -> Observable<Mutation>  {
        
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
        return .empty()
    }
}
