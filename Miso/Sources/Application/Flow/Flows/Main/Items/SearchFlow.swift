import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct SearchStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return MisoStep.searchTabbarIsRequired
    }
}

class SearchFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = SearchStepper()
    
    private lazy var rootViewController = UINavigationController()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
            
        case .searchTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        case .marketTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        case .inquiryTabbarIsRequired:
            return coordinateToSearchTabbar()
            
        case .settingTabbarIsRequired:
            return coordinateToSearchTabbar()
        
        case let .detailVCIsRequired(data):
            return coordinateToDetailVC(data: data)
            
        default:
            return .none
        }
    }
    
}
private extension SearchFlow {
    
    private func coordinateToDetailVC(data: UploadRecyclablesListResponse) -> FlowContributors {
        let reactor = DetailReactor(uploadRecyclablesList: data)
        let vc = DetailVC(reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToSearchTabbar() -> FlowContributors {
        let reactor = SearchReactor()
        let vc = SearchVC(reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
}

