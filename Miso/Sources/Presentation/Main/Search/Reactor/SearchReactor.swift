import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift

class SearchReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let recyclablesProvider = MoyaProvider<RecyclablesAPI>(plugins: [NetworkLoggerPlugin()])
    var recycleData: UploadRecyclablesListResponse?
    
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
        case cameraButtonTapped(image: Data)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var recycleData: UploadRecyclablesListResponse?
    }
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .cameraButtonTapped(image):
            return uploadImage(image: image)
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
extension SearchReactor {
    func uploadImage(image: Data) -> Observable<Mutation> {
        
            self.recyclablesProvider.request(.uploadImage(accessToken: self.accessToken, image: image)){ response in
                switch response {
                case let .success(result):
                    do {
                        self.recycleData = try result.map(UploadRecyclablesListResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200:
                        guard let data = self.recycleData else {return}
                        self.steps.accept(MisoStep.detailVCIsRequired(data))
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
