import RxFlow
import UIKit
import Moya
import RxSwift
import RxCocoa

struct AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let misoRefreshToken = MisoRefreshToken.shared

    init() {}
    
    func readyToEmitSteps() {
        self.misoRefreshToken.autoLogin {
            switch misoRefreshToken.statusCode {
            case 200:
                print(misoRefreshToken.statusCode)
                steps.accept(MisoStep.tabBarIsRequired)
            default:
                print(misoRefreshToken.statusCode)
                steps.accept(MisoStep.loginInIsRequired)
            }
        }
    }
}

final class AppFlow: Flow {
    
    var root: Presentable {
        return window
    }
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
        
    deinit{
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MisoStep else {return .none}
        
        switch step {
        case .loginInIsRequired:
            return coordinateToLogin()
//        case .tabBarIsRequired:
//            return coordinateToHome()
        default:
            return .none
        }
    }
    
    private func coordinateToLogin() -> FlowContributors {
        let flow = AuthFlow()
        Flows.use(flow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: flow,
                withNextStepper: OneStepper(withSingleStep: MisoStep.loginInIsRequired)
        ))
    }

//    private func coordinateToHome() -> FlowContributors {
//        let flow = TabBarFlow()
//        Flows.use(
//            flow,
//            when: .created
//        ) { [unowned self] root in
//            self.window.rootViewController = root
//        }
//        return .one(
//            flowContributor: .contribute(
//                withNextPresentable: flow,
//                withNextStepper: OneStepper(
//                    withSingleStep: MisoStep.tabBarIsRequired
//                )
//        ))
//    }
}
