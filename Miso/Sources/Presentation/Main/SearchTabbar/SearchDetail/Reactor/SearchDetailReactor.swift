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
