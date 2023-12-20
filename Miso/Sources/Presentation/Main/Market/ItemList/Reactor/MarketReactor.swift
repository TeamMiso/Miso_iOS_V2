import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class MarketReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let itemProvider = MoyaProvider<ItemAPI>(plugins: [NetworkLoggerPlugin()])
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
    
    var itemListResponse: ItemListResponse?
    var itemDetailResponse: ItemDetailListResponse?
    
    enum Action {
        case fetchItemList
        case itemDetailTapped(productId: String)
    }
    
    enum Mutation {
        case fetchItemListData([ItemListResponse.ItemList])
    }
    
    struct State {
        var itemListArray: [ItemListResponse.ItemList] = []
    }
    
    init() {
        self.initialState = State(itemListArray: [])
    }
}

extension MarketReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchItemList:
            return getItemList()
        case let .itemDetailTapped(productId):
            return toItemDetailVC(productId: productId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .fetchItemListData(data):
            newState.itemListArray = data
        }
        return newState
    }
}

// MARK: - Method
private extension MarketReactor {
    
    func toItemDetailVC(productId: String) -> Observable<Mutation> {
        itemProvider.request(.getItemDetailList(id: productId, accessToken: accessToken)){ response in
            switch response {
            case let .success(result):
                do {
                    self.itemDetailResponse = try result.map(ItemDetailListResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200:
                    guard let data = self.itemDetailResponse else { return }
                    self.steps.accept(MisoStep.itemDetailVCIsRequired(data))
                case 401:
                    print("토큰이 유효하지 않음")
                case 404:
                    print("물품을 찾을 수 없음")
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
    
    func getItemList() -> Observable<Mutation> {
        return Observable.create { observer in
            self.itemProvider.request(.getItemList(accessToken: self.accessToken)){ response in
                switch response {
                case let .success(result):
                    do {
                        self.itemListResponse = try result.map(ItemListResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200:
                        guard let data = self.itemListResponse?.itemList else { return }
                        observer.onNext(.fetchItemListData(data))
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
}
