//
//  GOMSStep.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit

enum MisoStep: Step {
    
    // MARK: - Auth
    case loginVCIsRequired
    case signupVCIsRequired
    case certificationVCIsRequied
    case tabbarVCIsRequired
    case findPasswordVCIsRequired
    
    // MARK: TabBar
    case tabBarIsRequired
    case searchTabbarIsRequired
    case marketTabbarIsRequired
    case cameraTabbarIsRequired
    case inquiryTabbarIsRequired
    case settingTabbarIsRequired
    
    
    //MARK: Alert
    case alert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    case failureAlert(title: String?, message: String?, action: [UIAlertAction] = [])
}

