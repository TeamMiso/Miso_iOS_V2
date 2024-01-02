import Foundation
import Moya
import RxMoya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class NotificationReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let notificationProvider = MoyaProvider<NotificationAPI>(plugins: [NetworkLoggerPlugin()])
    let keychain = Keychain()
    let misoRefreshToken = MisoRefreshToken.shared
    lazy var accessToken: String = {
        do {
            return "Bearer " + (try keychain.load(type: .accessToken))
        } catch {
            print("Refresh 토큰을 불러오는 중 에러 발생: \(error)")
            return "Bearer "
        }
    }()
    
    enum Action {
        case sendDeviceToken(deviceToken: String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    init() {
        self.initialState = State()
    }
}

extension NotificationReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .sendDeviceToken(deviceToken):
            return sendDeviceToken(deviceToken: deviceToken)
        }
        
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        
        }
        return newState
    }
}

// MARK: - Method
private extension NotificationReactor {
    func sendDeviceToken(deviceToken: String) -> Observable<Mutation> {
        self.notificationProvider.request(.sendDeviceToken(accessToken: self.accessToken, deviceToken: deviceToken)){ response in
            switch response {
            case let .success(result):
                let statusCode = result.statusCode
                switch statusCode{
                case 201:
                    print("deviceToken 전송 성공")
                case 401:
                    print("토큰이 유효하지 않음")
                case 500:
                    print("에러 500")
                default:
                    print("에러 발생 !")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
        return .empty()
    }
}
