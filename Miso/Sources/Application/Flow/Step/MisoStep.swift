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
    case coordinateToSearchVCIsRequired
    case cameraIsRequired
    case aiResultVCIsRequired(UploadRecyclablesListResponse, UIImage)
    case searchResultVCIsRequired(DetailRecyclablesListResponse)
    
    // MARK: - Market
    case purchaseHistoryVCIsRequired
    case itemDetailVCIsRequired(ItemDetailListResponse)
    case coordinateToMarketVCIsRequired
    
    // MARK: - Inquiry
    case detailInquiryVCIsRequired(DetailInquiryResponse)
    case writeInquiryVCIsRequired
    
    // MARK: - Setting
    
    //MARK: Alert
    case alert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    case failureAlert(title: String?, message: String?, action: [UIAlertAction] = [])
}

