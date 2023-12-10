import RxFlow
import UIKit
import RxCocoa
import RxSwift
import Then

struct AuthStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return MisoStep.loginVCIsRequired
    }
}

class AuthFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
        case .loginVCIsRequired:
            return coordinateToLogin()
            
        case .signupVCIsRequired:
            return coordinateToSignup()
            
        case .certificationVCIsRequied:
            return coordinateCertification()
            
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
    
    func coordinateToSignup() -> FlowContributors {
        let reactor = AuthReactor()
        let vc = SignupVC(reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    func coordinateCertification() -> FlowContributors {
        let reactor = AuthReactor()
        let vc = CertificationVC(reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
