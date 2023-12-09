import RxFlow
import UIKit

class AuthFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
        case .loginInIsRequired:
            return coordinateToLogin()
        case .tabBarIsRequired:
            return .end(forwardToParentFlowWithStep: MisoStep.tabBarIsRequired)
        default:
            return .none
        }
    }
}

private extension AuthFlow {
    func coordinateToLogin() -> FlowContributors {
        let reactor = AuthReactor()
        let vc = LoginVC(reactor)
        self.rootViewController.setViewControllers([vc], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
