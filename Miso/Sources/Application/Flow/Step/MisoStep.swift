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
    case inquiryTabbarIsRequired
    case settingTabbarIsRequired
    
    // MARK: - Search
    case cameraIsRequired
    
    // MARK: - Detail
    case detailVCIsRequired(UploadRecyclablesListResponse, UIImage)
    case coordinateToSearchVCIsRequired
    
    
    //MARK: Alert
    case alert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    case failureAlert(title: String?, message: String?, action: [UIAlertAction] = [])
}

