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
    
    var detailRecycleArray: [DetailRecyclablesListResponse] = []
    var detailRecycleResponse: DetailRecyclablesListResponse?
    
    var searchRecycleResponse: SearchRecyclablesListResponse?
    let defaultSearchRecycleData = SearchRecyclablesListResponse(
        title: "Default Title",
        imageUrl: "Default Image URL",
        recycleMethod: "Default Recycling Method",
        recyclablesType: "Default Recycling Type"
    )

    var uploadRecycleResponse: UploadRecyclablesListResponse?
    
    enum Action {
        case detailButtonTapped(recycleType: String)
        case searchRecycle(searchText: String)
        case cameraButtonTapped(imageData: Data, originalImage: UIImage)
    }
    
    enum Mutation {
        case fetchSearchData(SearchRecyclablesListResponse)
    }
    
    struct State {
        var title: String
        var imageUrl: String
        var recycleMethod: String
        var recyclablesType: String
    }
    
    init() {
        self.initialState = State(title: "", imageUrl: "", recycleMethod: "", recyclablesType: "")
    }
}

extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .detailButtonTapped(recycleType):
            return toDetailVC(recycleType: recycleType)
        case let .searchRecycle(searchText):
            return searchRecycle(searchText: searchText)
        case let .cameraButtonTapped(imageData, originalImage):
            return uploadImage(imageData: imageData, originalImage: originalImage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .fetchSearchData(data):
            newState.title = data.title
            newState.imageUrl = data.imageUrl
            newState.recycleMethod = data.recycleMethod
            newState.recyclablesType = data.recyclablesType
        }
        return newState
    }
}

// MARK: - Method
private extension SearchReactor {
    func toDetailVC(recycleType: String) -> Observable<Mutation> {
        recyclablesProvider.request(.getDetailRecyclables(accessToken: accessToken, recycleType: recycleType)){ response in
            switch response {
            case let .success(result):
                do {
                    self.detailRecycleResponse = try result.map(DetailRecyclablesListResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200:
                    guard let data = self.detailRecycleResponse else {return}
                    self.steps.accept(MisoStep.searchResultVCIsRequired(data))
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
    
    func searchRecycle(searchText: String) -> Observable<Mutation> {
        return Observable.create { observer in
            self.recyclablesProvider.request(.searchRecyclables(accessToken: self.accessToken, searchText: searchText)){ response in
                switch response {
                case let .success(result):
                    do {
                        self.searchRecycleResponse = try result.map(SearchRecyclablesListResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200:
                        guard let data = self.searchRecycleResponse else {return}
                        observer.onNext(.fetchSearchData(data))
                    case 401:
                        print("토큰이 유효하지 않음")
                    case 404:
                        print("재활용 페이지를 찾을 수 없음")
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
    
    func uploadImage(imageData: Data, originalImage: UIImage) -> Observable<Mutation> {
        recyclablesProvider.request(.uploadImage(accessToken: self.accessToken, image: imageData, originalImage: originalImage)){ response in
            switch response {
            case let .success(result):
                do {
                    self.uploadRecycleResponse = try result.map(UploadRecyclablesListResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200:
                    guard let data = self.uploadRecycleResponse else {return}
                    self.steps.accept(MisoStep.aiResultVCIsRequired(data, originalImage))
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
