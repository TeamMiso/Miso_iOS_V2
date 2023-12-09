import Moya
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class BaseVM {
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    let keychain = Keychain()
//    let refreshToken = GOMSRefreshToken.shared
//    lazy var accessToken = try keychain.load(type: .accessToken)

}
