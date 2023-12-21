import Foundation
import Moya
import RxMoya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class InquiryReactor: Reactor, Stepper {
    
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    var initialState: State
    let inquiryProvider = MoyaProvider<InquiryAPI>(plugins: [NetworkLoggerPlugin()])
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
    
    var myInquiryResponse: MyInquiryResponse?
    
    enum Action {
        case fetchInquiryList
        case inquiryDetaillButtonTapped(inquiry: String)
    }
    
    enum Mutation {
        case fetchInquiryListData([MyInquiryResponse.MyInquiryList])
    }
    
    struct State {
        var myInquiryResponse: [MyInquiryResponse.MyInquiryList] = []
    }
    
    init() {
        self.initialState = State(myInquiryResponse: [])
    }
}

extension InquiryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchInquiryList:
            return fetchInquiryList()
        case let .inquiryDetaillButtonTapped(inquiry):
            return toInquiryVC(inquiryId: inquiry)
        }
        
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .fetchInquiryListData(data):
            newState.myInquiryResponse = data
        }
        return newState
    }
}

// MARK: - Method
private extension InquiryReactor {
    
    func fetchInquiryList() -> Observable<Mutation> {
        return Observable.create { observer in
            self.inquiryProvider.request(.getMyInquiryList(accessToken: self.accessToken)){ response in
                switch response {
                case let .success(result):
                    do {
                        self.myInquiryResponse = try result.map(MyInquiryResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200:
                        guard let data = self.myInquiryResponse?.inquiryList else { return }
                        observer.onNext(.fetchInquiryListData(data))
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
    
    func toInquiryVC(inquiryId: String) -> Observable<Mutation> {
        self.inquiryProvider.request(.){ response in
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
}

