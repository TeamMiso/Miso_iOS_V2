import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class InquiryDetailReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    
    var detailInquiryResponse: DetailInquiryResponse?

    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var detailInquiryResponse: DetailInquiryResponse?
        
        init(detailInquiryResponse: DetailInquiryResponse?) {
            self.detailInquiryResponse = detailInquiryResponse
        }
    }
    
    
    init(detailRecyclablesList: DetailRecyclablesListResponse? = nil) {
        self.initialState = State(detailInquiryResponse: detailInquiryResponse)
    }
}

extension InquiryDetailReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}
