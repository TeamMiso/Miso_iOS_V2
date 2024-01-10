import Foundation
import Moya
import RxMoya
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class WriteInquiryReactor: Reactor, Stepper {
    
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
    
    enum Action {
        case addImageButtonDidTap
        case writeInquiryComplished(title: String, image: UIImage, content: String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    init() {
        self.initialState = State()
    }
}

extension WriteInquiryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addImageButtonDidTap:
            return addImageButtonDidTap()
        case let .writeInquiryComplished(title, image, content):
            return writeInquiryComplished(title: title, image: image, content: content)
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}

// MARK: - Method
private extension WriteInquiryReactor {
    func addImageButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(MisoStep.alert(
            title: "사진 업로드",
            message: "",
            style: .actionSheet,
            actions: [
                UIAlertAction(title: "카메라로 찍기", style: .default){ (_) in
//                    self.steps.accept(MisoStep.searchTabbarIsRequired)
                },
                UIAlertAction(title: "갤러리에서 선택", style: .default) { (_) in
//                    self.steps.accept(MisoStep.popToRootVCIsRequired)
                },
                UIAlertAction(title: "취소", style: .cancel) { (_) in
//                    self.steps.accept(MisoStep.popToRootVCIsRequired)
                }
            ])
        )
        return .empty()
    }
    
    func writeInquiryComplished(title: String, image: UIImage, content: String) -> Observable<Mutation> {
        self.inquiryProvider.request(.askInquiry(accessToken: self.accessToken, image: image, title: title, content: content)){ response in
            switch response {
            case let .success(result):
                let statusCode = result.statusCode
                switch statusCode{
                case 201:
                    self.steps.accept(MisoStep.alert(
                        title: "문의 성공",
                        message: "문의사항이 게시되었어요. \n게시글을 보러 가시겠어요?",
                        style: .alert,
                        actions: [
                            UIAlertAction(title: "홈으로", style: .default){ (_) in
                                self.steps.accept(MisoStep.searchTabbarIsRequired)
                            },
                            UIAlertAction(title: "게시글로", style: .default) { (_) in
                                self.steps.accept(MisoStep.popToRootVCIsRequired)
                            }
                        ])
                    )
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
