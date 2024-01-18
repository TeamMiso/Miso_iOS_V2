import Foundation
import Moya
import RxMoya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class PurchaseHistoryReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let purchaseProvider = MoyaProvider<PurchaseAPI>(plugins: [NetworkLoggerPlugin()])
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
    
    var purchaseHistoryResponse: PurchaseHistoryResponse?
    
    enum Action {
        case fetchPurchaseHistoryList
    }
    
    enum Mutation {
        case fetchItemListData([PurchaseHistoryResponse.PurchaseList])
    }
    
    struct State {
        var purchaseHistoryResponse: [PurchaseHistoryResponse.PurchaseList] = []
    }
    
    init() {
        self.initialState = State(purchaseHistoryResponse: [])
    }
}

extension PurchaseHistoryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPurchaseHistoryList:
            return fetchPurchaseHistoryList()
        }
        
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .fetchItemListData(data):
            newState.purchaseHistoryResponse = data
        }
        return newState
    }
}

// MARK: - Method
private extension PurchaseHistoryReactor {
    func fetchPurchaseHistoryList() -> Observable<Mutation> {
        return self.purchaseProvider.rx.request(.puchaseHistory(accessToken: accessToken))
            .map(PurchaseHistoryResponse.self)
            .map(\.purchaseList)
            .map(Mutation.fetchItemListData)
            .asObservable()
    }
}
