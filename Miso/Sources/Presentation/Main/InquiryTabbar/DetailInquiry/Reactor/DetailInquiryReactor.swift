import Foundation
import Moya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class DetailInquiryReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let notificationProvider = MoyaProvider<NotificationAPI>(plugins: [NetworkLoggerPlugin()])
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
    
    var detailInquiryResponse: DetailInquiryResponse?
    var myInquiryAnswerResponse: MyInquiryAnswerResponse?

    enum Action {
        case fetchInquiryResponse(id: Int)
    }
    
    enum Mutation {
        case fetchInquiryResponseData(MyInquiryAnswerResponse)
    }
    
    struct State {
        var detailInquiryResponse: DetailInquiryResponse?
        var myInquiryResponse: MyInquiryAnswerResponse?
        
        init(detailInquiryResponse: DetailInquiryResponse?, myInquiryResponse: MyInquiryAnswerResponse?) {

            self.detailInquiryResponse = detailInquiryResponse
            self.myInquiryResponse = myInquiryResponse
        }
        
    }
    
    init(detailInquiryResponse: DetailInquiryResponse? = nil, myInquiryResponse: MyInquiryAnswerResponse? = nil) {
        self.initialState = State(detailInquiryResponse: detailInquiryResponse, myInquiryResponse: myInquiryResponse)
    }
}

extension DetailInquiryReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .fetchInquiryResponse(id):
            return getMyInquiryAnswer(id: id)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchInquiryResponseData(data):
            newState.myInquiryResponse = data
        }
        return newState
    }
}


private extension DetailInquiryReactor {
    func getMyInquiryAnswer(id: Int) -> Observable<Mutation> {
        return Observable.create { observer in
            self.notificationProvider.request(.getMyInquiryAnswer(accessToken: self.accessToken, id: id)){ response in
                switch response {
                case let .success(result):
                    do {
                        self.myInquiryAnswerResponse = try result.map(MyInquiryAnswerResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200:
                        guard let data = self.myInquiryAnswerResponse else { return }
                        observer.onNext(.fetchInquiryResponseData(data))
                    case 401:
                        print("토큰이 유효하지 않음")
                    case 404:
                        print("문의 사항 답변을 찾을 수 없음")
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
