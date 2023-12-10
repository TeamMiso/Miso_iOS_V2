import RxFlow
import UIKit

final class TabBarFlow: Flow {
    
    enum TabIndex: Int {
        case home = 0
        case qrCode = 1
        case outing = 2
    }
    
    var root: Presentable {
        return self.rootVC
    }
    
    private let rootVC = MisoTabBarVC()
    
    private var searchFlow = SearchFlow()
    private var marketFlow = SearchFlow()
    private var cameraFlow = SearchFlow()
    private var inquiryFlow = SearchFlow()
    private var settingFlow = SearchFlow()
    
    init() {}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else {return .none}
        
        switch step {
        case .tabBarIsRequired:
            return coordinateToTabbar()
            
        case .searchTabbarIsRequired:
            rootVC.selectedIndex = 0
            return .none
            
        case .marketTabbarIsRequired:
            rootVC.selectedIndex = 1
            return .none
            
        case .cameraTabbarIsRequired:
            rootVC.selectedIndex = 2
            return .none
            
        case .inquiryTabbarIsRequired:
            rootVC.selectedIndex = 3
            return .none
            
        case .settingTabbarIsRequired:
            rootVC.selectedIndex = 4
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
            searchFlow, marketFlow, cameraFlow, inquiryFlow, settingFlow,
            when: .ready
        ) { [unowned self] ( 
            root1: UINavigationController,
            root2: UINavigationController,
            root3: UINavigationController,
            root4: UINavigationController,
            root5: UINavigationController) in

            let searchItem = UITabBarItem(
                title: "검색",
                image: UIImage(named: "Search"),
                selectedImage: UIImage(named: "Search.selected")
            )
            let marketItem = UITabBarItem(
                title: "상점",
                image: UIImage(named: "Market"),
                selectedImage: UIImage(named: "Market.selected")
            )
            let cameraItem = UITabBarItem(
                title: "카메라",
                image: UIImage(named: "Camera"),
                selectedImage: UIImage(named: "Camera")
            )
            let inquiryItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "Inquiry"),
                selectedImage: UIImage(named: "Inquiry.selected")
            )
            let settingItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "Setting"),
                selectedImage: UIImage(named: "Setting.selected")
            )
            
        
            root1.tabBarItem = searchItem
            root2.tabBarItem = marketItem
            root3.tabBarItem = cameraItem
            root4.tabBarItem = inquiryItem
            root5.tabBarItem = settingItem
            
            self.rootVC.setViewControllers([root1,root2,root3,root4,root5], animated: true)
        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: searchFlow, withNextStepper: OneStepper(withSingleStep: MisoStep.searchTabbarIsRequired)),
            .contribute(withNextPresentable: marketFlow, withNextStepper: OneStepper(withSingleStep: MisoStep.marketTabbarIsRequired)),
            .contribute(withNextPresentable: cameraFlow, withNextStepper: OneStepper(withSingleStep: MisoStep.cameraTabbarIsRequired)),
            .contribute(withNextPresentable: inquiryFlow, withNextStepper: OneStepper(withSingleStep: MisoStep.inquiryTabbarIsRequired)),
            .contribute(withNextPresentable: settingFlow, withNextStepper: OneStepper(withSingleStep: MisoStep.settingTabbarIsRequired))
        ])
    }
}

