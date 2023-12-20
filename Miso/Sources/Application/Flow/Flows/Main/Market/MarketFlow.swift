import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct MarketStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return MisoStep.marketTabbarIsRequired
    }
}

class MarketFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = MarketStepper()
    
    private lazy var rootViewController = UINavigationController()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else { return .none }
        switch step {
        case .marketTabbarIsRequired:
            return coordinateToMarketTabbar()
        case .purchaseHistoryVCIsRequired:
            return coordinateToPurchaseHistoryVC()
        case let .itemDetailVCIsRequired(data):
            return coordinateToItemDetailVC(data: data)
        case .coordinateToMarketVCIsRequired:
            return coordinateToMarketVC()
        default:
            return .none
        }
    }
    
}

private extension MarketFlow {
    
    private func coordinateToMarketTabbar() -> FlowContributors {
        let reactor = MarketReactor()
        let vc = MarketVC(reactor: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToPurchaseHistoryVC() -> FlowContributors {
        let reactor = PurchaseHistoryReactor()
        let vc = PurchaseHistoryVC(reactor: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToItemDetailVC(data: ItemDetailListResponse) -> FlowContributors {
        let reactor = ItemDetailReactor(itemDetailList: data)
        let vc = ItemDetailVC(reactor: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToMarketVC() -> FlowContributors {
        let reactor = MarketReactor()
        let vc = MarketVC(reactor: reactor)
        self.rootViewController.popToRootViewController(animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToSearchVC() -> FlowContributors {
        print("coordinate")
        let reactor = SearchReactor()
        let vc = SearchVC(reactor: reactor)
        self.rootViewController.popToRootViewController(animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
