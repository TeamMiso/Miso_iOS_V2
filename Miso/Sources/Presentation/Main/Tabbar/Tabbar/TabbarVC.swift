import UIKit

final class MisoTabBarVC: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension MisoTabBarVC {
    func configureVC() {
        tabBar.tintColor = UIColor(rgb: 0x25D07D)
        tabBar.unselectedItemTintColor = UIColor(rgb: 0xBFBFBF)
        tabBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
}
