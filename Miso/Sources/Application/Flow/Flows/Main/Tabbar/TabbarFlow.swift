import RxFlow
import UIKit
import RxSwift
import RxCocoa


struct TabBarStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return MisoStep.tabBarIsRequired
    }
}

final class TabBarFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = SearchStepper()
    
    private let rootViewController = MisoTabBarVC()
    
    private var searchFlow = SearchFlow()
    private var marketFlow = MarketFlow()
    private var inquiryFlow = InquiryFlow()
    private var settingFlow = SearchFlow()
    
    init() {}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else {return .none}
        
        switch step {
        case .tabBarIsRequired:
            return coordinateToTabbar()
            
        case .searchTabbarIsRequired:
            rootViewController.selectedIndex = 0
            return .none
            
        case .marketTabbarIsRequired:
            rootViewController.selectedIndex = 1
            return .none
            
        case .inquiryTabbarIsRequired:
            rootViewController.selectedIndex = 2
            return .none
            
        case .settingTabbarIsRequired:
            rootViewController.selectedIndex = 3
            return .none
            
        case .loginVCIsRequired:
            return .end(forwardToParentFlowWithStep: MisoStep.loginVCIsRequired)
            
        default:
            return .none
        }
    }
}

private extension TabBarFlow {
    
    func coordinateToTabbar() -> FlowContributors {
        Flows.use(
            searchFlow, marketFlow, inquiryFlow, settingFlow,
            when: .ready
        ) { [unowned self] (
            root1: UINavigationController,
            root2: UINavigationController,
            root3: UINavigationController,
            root4: UINavigationController) in
            
            let searchItem = UITabBarItem(
                title: "검색",
                image: UIImage(systemName: "magnifyingglass"),
                selectedImage: UIImage(systemName: "magnifyingglass")
            )
            let marketItem = UITabBarItem(
                title: "상점",
                image: UIImage(systemName: "storefront"),
                selectedImage: UIImage(systemName: "storefront")
            )
            let inquiryItem = UITabBarItem(
                title: "문의",
                image: UIImage(systemName: "questionmark.bubble"),
                selectedImage: UIImage(systemName: "questionmark.bubble")
            )
            let settingItem = UITabBarItem(
                title: "설정",
                image: UIImage(systemName: "gearshape"),
                selectedImage: UIImage(systemName: "gearshape")
            )
            
            root1.tabBarItem = searchItem
            root2.tabBarItem = marketItem
            root3.tabBarItem = inquiryItem
            root4.tabBarItem = settingItem
            
            self.rootViewController.setViewControllers([root1,root2,root3,root4], animated: true)
        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: searchFlow, withNextStepper: searchFlow.stepper),
            .contribute(withNextPresentable: marketFlow, withNextStepper: marketFlow.stepper),
            .contribute(withNextPresentable: inquiryFlow, withNextStepper: inquiryFlow.stepper),
            .contribute(withNextPresentable: settingFlow, withNextStepper: settingFlow.stepper)
        ])
    }
}
