import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct InquiryStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return MisoStep.inquiryTabbarIsRequired
    }
}

class InquiryFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = InquiryStepper()
    
    private lazy var rootViewController = UINavigationController()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
        case .inquiryTabbarIsRequired:
            return coordinateToInquiryTabbar()
        case let .detailInquiryVCIsRequired(data):
            return coordinateToInquiryDetailVC(data: data)
        case .writeInquiryVCIsRequired:
            return coordinateToWriteInquiryVC()
        case let .alert(title ,message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
        default:
            return .none
        }
    }
    
}

private extension InquiryFlow {
    
    private func coordinateToInquiryTabbar() -> FlowContributors {
        let reactor = InquiryReactor()
        let vc = InquiryVC(reactor: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToInquiryDetailVC(data: DetailInquiryResponse) -> FlowContributors {
        let reactor = DetailInquiryReactor(detailInquiryResponse: data)
        let vc = DetailInquiryVC(reactor: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToWriteInquiryVC() -> FlowContributors {
        let reactor = WriteInquiryReactor()
        let vc = WriteInquiryVC(reactor: reactor)
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
