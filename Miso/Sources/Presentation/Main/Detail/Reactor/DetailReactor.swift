import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift

class DetailReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    var uploadRecyclablesList: UploadRecyclablesListResponse?
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var uploadRecyclablesList: UploadRecyclablesListResponse?
        
        init(uploadRecyclablesList: UploadRecyclablesListResponse?) {
            self.uploadRecyclablesList = uploadRecyclablesList
        }
    }
    
    
    init(uploadRecyclablesList: UploadRecyclablesListResponse? = nil) {
        self.initialState = State(uploadRecyclablesList: uploadRecyclablesList)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}
