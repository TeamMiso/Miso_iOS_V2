import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

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
        case cameraButtonTapped(imageData: Data, originalImage: UIImage)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var recycleData: UploadRecyclablesListResponse?
    }
    
    init() {
        self.initialState = State()
    }
    
}
extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .cameraButtonTapped(imageData, originalImage):
            return uploadImage(imageData: imageData, originalImage: originalImage)
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
private extension SearchReactor {
    func uploadImage(imageData: Data, originalImage: UIImage) -> Observable<Mutation> {
        
        self.recyclablesProvider.request(.uploadImage(accessToken: self.accessToken, image: imageData, originalImage: originalImage)){ response in
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
                        self.steps.accept(MisoStep.detailVCIsRequired(data, originalImage))
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
