import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class ItemDetailReactor: Reactor, Stepper {
    
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
    
    var itemDetailList: ItemDetailListResponse?

    enum Action {
        case buyButtonTapped(id: Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var itemDetailList: ItemDetailListResponse?
        
        init(itemDetailList: ItemDetailListResponse?) {
            self.itemDetailList = itemDetailList
        }
    }
    
    init(itemDetailList: ItemDetailListResponse? = nil) {
        self.initialState = State(itemDetailList: itemDetailList)
    }
}

extension ItemDetailReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .buyButtonTapped(id):
            return buyButtonTapped(id: id)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}


private extension ItemDetailReactor {
    private func buyButtonTapped(id: Int) -> Observable<Mutation>  {
        purchaseProvider.request(.buyItem(id: id, accessToken: accessToken)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                switch statusCode{
                case 201:
                    self.steps.accept(MisoStep.alert(
                        title: "상품 구매하기",
                        message: "상품을 구매하실건가요?",
                        style: .alert,
                        actions: [
                            UIAlertAction(title: "취소", style: .cancel),
                            UIAlertAction(title: "구매", style: .default)
                        ])
                    )
                case 401:
                    print("토큰이 유효하지 않습니다.")
                case 403:
                    print("포인트가 충분하지 않습니다.")
                case 404:
                    print("물품을 찾을 수 없습니다.")
                case 410:
                    print("아이템의 재고가 남아있지 않습니다.")
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
