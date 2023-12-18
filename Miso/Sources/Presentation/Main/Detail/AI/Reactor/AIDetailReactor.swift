import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class AIDetailReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let userProvider = MoyaProvider<UserAPI>(plugins: [NetworkLoggerPlugin()])
    
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
    
//    var uploadRecyclablesList: UploadRecyclablesListResponse?
    var originalImage: UIImage?
    
    
    enum Action {
        case pointButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var uploadRecyclablesList: UploadRecyclablesListResponse?
        var originalImage: UIImage?
        
        init(uploadRecyclablesList: UploadRecyclablesListResponse?, originalImage: UIImage?) {
            self.uploadRecyclablesList = uploadRecyclablesList
            self.originalImage = originalImage
        }
    }
    
    
    init(uploadRecyclablesList: UploadRecyclablesListResponse? = nil, originalImage: UIImage? = nil) {
        self.initialState = State(uploadRecyclablesList: uploadRecyclablesList, originalImage: originalImage)
    }
}

extension AIDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        return pointButtonTapped()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}

private extension AIDetailReactor {
    private func pointButtonTapped() -> Observable<Mutation>  {
        userProvider.request(.giveUserPoint(accessToken: accessToken)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                switch statusCode{
                case 200:
                    print("point 주기")
                    self.steps.accept(MisoStep.coordinateToSearchVCIsRequired)
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
        return .empty()
    }
}
