import UIKit
import SnapKit
import Then

final class SplashVC: UIViewController {
    
    private let misoLogoImage = UIImageView().then {
        $0.image = UIImage(named: "MisoLogo-White")
    }
    
    func setLayout() {
        misoLogoImage.snp.makeConstraints {
            $0.height.width.equalTo(160)
            $0.center.equalToSuperview()
        }
    }
    
    func addviews(){
        view.addSubview(
            misoLogoImage
        )
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(rgb: 0x25D07D)
        addviews()
        setLayout()
    }
    
}
