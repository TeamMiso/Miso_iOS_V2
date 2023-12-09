//import RxFlow
//import UIKit
//
//final class TabBarFlow: Flow {
//    
//    enum TabIndex: Int {
//        case home = 0
//        case qrCode = 1
//        case outing = 2
//    }
//    
//    var root: Presentable {
//        return self.rootVC
//    }
//    
//    private let rootVC = GOMSTabBarViewController()
//    
//    private var homeFlow = HomeFlow()
//    private var qrCodeFlow = QRCodeFlow()
//    private var outingFlow = OutingFlow()
//    private let keychain = Keychain()
//    private lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
//    
//    init() {}
//    
//    func navigate(to step: Step) -> FlowContributors {
//        guard let step = step as? GOMSStep else {return .none}
//        
//        switch step {
//        case .tabBarIsRequired:
//            return coordinateToTabbar()
//            
//        case .homeIsRequired:
//            rootVC.selectedIndex = 0
//            return .none
//            
//        case .qrocdeIsRequired:
//            rootVC.selectedIndex = 1
//            return .none
//            
//        case .outingIsRequired:
//            rootVC.selectedIndex = 2
//            return .none
//            
//        case .introIsRequired:
//            return .end(forwardToParentFlowWithStep: GOMSStep.introIsRequired)
//            
//        default:
//            return .none
//        }
//    }
//    
//}
//
//private extension TabBarFlow {
//    func coordinateToTabbar() -> FlowContributors {
//        Flows.use(
//            homeFlow, qrCodeFlow, outingFlow,
//            when: .ready
//        ) { [unowned self] (root1: UINavigationController,
//                            root2: UINavigationController,
//                            root3: UINavigationController) in
//            lazy var userIsOuting = UserDefaults.standard.bool(forKey: "userIsOuting")
//            
//            
//            root1.tabBarItem = homeItem
//            root2.tabBarItem = qrCodeItem
//            root3.tabBarItem = outingItem
//            
//            self.rootVC.setViewControllers([root1,root2,root3], animated: true)
//        }
//        return .multiple(flowContributors: [
//            .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: GOMSStep.homeIsRequired)),
//            .contribute(withNextPresentable: qrCodeFlow, withNextStepper: OneStepper(withSingleStep: GOMSStep.qrocdeIsRequired)),
//            .contribute(withNextPresentable: outingFlow, withNextStepper: OneStepper(withSingleStep: GOMSStep.outingIsRequired))
//        ])
//    }
//}
//
