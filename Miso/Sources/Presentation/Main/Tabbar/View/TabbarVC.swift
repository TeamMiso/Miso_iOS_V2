import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

final class MisoTabBarVC: UITabBarController{
    var disposeBag = DisposeBag()
    
    func configureVC() {
        tabBar.tintColor = UIColor(rgb: 0x25D07D)
        tabBar.unselectedItemTintColor = UIColor(rgb: 0xBFBFBF)
        tabBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
