import SwiftUI
import RxSwift
import RxCocoa
import RxFlow
import Moya

class BaseVM: ObservableObject { // 수정: ObservableObject 채택
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    let keychain = Keychain()
    let misoRefreshToken = MisoRefreshToken.shared
    
    lazy var accessToken: String = {
        do {
            return "Bearer " + (try keychain.load(type: .accessToken) ?? "")
        } catch {
            print("Refresh 토큰을 불러오는 중 에러 발생: \(error)")
            return "Bearer "
        }
    }()
}
