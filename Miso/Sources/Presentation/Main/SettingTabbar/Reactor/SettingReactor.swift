import Foundation
import Moya
import RxMoya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class SettingReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let userProvider = MoyaProvider<UserAPI>(plugins: [NetworkLoggerPlugin()])
    let authProvider = MoyaProvider<AuthAPI>(plugins: [NetworkLoggerPlugin()])
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
    
    var userInfoResponse: GetUserInfoResponse?
    
    enum Action {
        case fetchUserInfoResponse
        case logoutButtonDidTap
    }
    
    enum Mutation {
        case fetchUserInfoResponseData(GetUserInfoResponse)
    }
    
    struct State {
        var userInfoResponse: GetUserInfoResponse?
    }
    
    init() {
        self.initialState = State(userInfoResponse: userInfoResponse)
    }
}

extension SettingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchUserInfoResponse:
            return fetchInquiryList()
        case .logoutButtonDidTap:
            return logout()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchUserInfoResponseData(data):
            newState.userInfoResponse = data
        }
        return newState
    }
}

// MARK: - Method
private extension SettingReactor {
    
    private func fetchInquiryList() -> Observable<Mutation> {
        return Observable.create { observer in
            self.userProvider.request(.getUserInfo(accessToken: self.accessToken)){ response in
                switch response {
                case let .success(result):
                    do {
                        self.userInfoResponse = try result.map(GetUserInfoResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200:
                        guard let data = self.userInfoResponse else { return }
                        observer.onNext(.fetchUserInfoResponseData(data))
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
            return Disposables.create()
        }
    }
    
    private func logout() -> Observable<Mutation> {
        self.steps.accept(MisoStep.alert(
            title: "로그아웃",
            message: "로그아웃하시겠습니까?",
            style: .alert,
            actions: [
                UIAlertAction(title: "취소", style: .default),
                UIAlertAction(title: "로그아웃", style: .destructive) { (_) in
                    self.authProvider.request(.logout(accessToken: self.accessToken)) { response in
                        switch response {
                        case .success(let result):
                            let statusCode = result.statusCode
                            switch statusCode{
                            case 204:
                                self.steps.accept(MisoStep.loginVCIsRequired)
                                self.deleteUserToken()
                            case 401:
                                print("토큰이 유효하지 않습니다.")
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
                }
            ])
        )
        return .empty()
    }
    
    private func deleteUserToken() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
    }
}
