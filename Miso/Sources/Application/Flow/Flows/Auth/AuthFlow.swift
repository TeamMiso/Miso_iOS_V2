import RxFlow
import UIKit

class AuthFlow: Flow {
    var root: Presentable {
        return rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
        case .loginIsRequired:
            return coordinateToLogin()
        default:
            return .none
        }
    }
}

private extension AuthFlow {
    func coordinateToLogin() -> FlowContributors {
        let vm = LoginVM()
        let vc = LoginVC(vm)
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
}
