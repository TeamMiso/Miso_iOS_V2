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
    case loginInIsRequired
    case signupIsRequired
    case certificationNumberIsRequied
    case mainVCIsRequired
    case findPassword_phoneNumberAuth
    
    // MARK: TabBar
    case tabBarIsRequired
    
    // MARK: Home
    case searchIsRequired
    case marketIsRequired
    case requestIsRequired
    case settingIsRequired
    
    case studentInfoIsRequired
    case searchModalIsRequired
    case searchModalDismiss
    case editUserModalIsRequired(accountIdx: UUID)
    case editModalDismiss
    
    //MARK: Alert
    case alert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    case failureAlert(title: String?, message: String?, action: [UIAlertAction] = [])
}

