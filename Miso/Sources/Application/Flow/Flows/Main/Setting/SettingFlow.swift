import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct SettingStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return MisoStep.settingTabbarIsRequired
    }
}

class SettingFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = SettingStepper()
    
    private lazy var rootViewController = UINavigationController()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
        case .settingTabbarIsRequired:
            return coordinateTosettingTabbar()
        case let .alert(title ,message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
        case .loginVCIsRequired:
            return .end(forwardToParentFlowWithStep: MisoStep.loginVCIsRequired)
        default:
            return .none
        }
    }
    
}

private extension SettingFlow {
    private func coordinateTosettingTabbar() -> FlowContributors {
        let reactor = SettingReactor()
        let vc = SettingVC(reactor: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    func presentToAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
}
