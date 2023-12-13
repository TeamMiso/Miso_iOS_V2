import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct CameraStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return MisoStep.cameraTabbarIsRequired
    }
}

class CameraFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = CameraStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
            
        case .searchTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        case .marketTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        case .cameraTabbarIsRequired:
            return coordinateToCameraTabbar()
            
        case .inquiryTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        case .settingTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        default:
            return .none
        }
    }
    
    private func coordinateToSearchTabbar() -> FlowContributors {
        let vm = SearchVM()
        let vc = SearchVC(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func coordinateToCameraTabbar() -> FlowContributors {
        let vm = CameraReactor()
        let vc = CameraVC(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func presentToAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
    
    private func presentToFailureAlert(title: String?, message: String?, action: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !action.isEmpty {
            action.forEach(alert.addAction(_:))
        } else {
            alert.addAction(.init(title: "확인", style: .default))
        }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
}


