import Moya
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class BaseVM {
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    let keychain = Keychain()
//    let gomsRefreshToken = GOMSRefreshToken.shared
//    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
}
