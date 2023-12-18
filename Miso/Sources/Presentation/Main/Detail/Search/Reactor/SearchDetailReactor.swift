import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class SearchDetailReactor: Reactor, Stepper {
    
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
    
    var detailRecyclablesList: DetailRecyclablesListResponse?

    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var detailRecyclablesList: DetailRecyclablesListResponse?
        
        init(detailRecyclablesList: DetailRecyclablesListResponse?) {
            self.detailRecyclablesList = detailRecyclablesList
        }
    }
    
    
    init(detailRecyclablesList: DetailRecyclablesListResponse? = nil) {
        self.initialState = State(detailRecyclablesList: detailRecyclablesList)
    }
}

extension SearchDetailReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}

