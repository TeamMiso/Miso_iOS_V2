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
    
    var itemListArray: ItemListResponse?
    
    enum Action {
        case fetchItemList
    }
    
    enum Mutation {
        case fetchItemListData(ItemListResponse)
    }
    
    struct State {
        var itemListArray: [ItemListResponse] = []
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .fetchItemListData(data):
            newState.itemListArray.append(data)
        }
        return newState
    }
}

// MARK: - Method
private extension MarketReactor {
    func getItemList() -> Observable<Mutation> {
        itemProvider.request(.getItemList(accessToken: accessToken)){ response in
            switch response {
            case let .success(result):
                do {
                    self.itemListArray = try result.map(ItemListResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200:
                    print(self.itemListArray)
//                    guard let data = self.detailRecycleResponse else {return}
                    
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
