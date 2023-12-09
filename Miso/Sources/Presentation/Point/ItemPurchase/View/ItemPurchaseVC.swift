//import UIKit
//
//final class ItemPurchaseVC: BaseVC {
//    
////    var productId: Int?
////    var productPrice: Int?
////    var productAmount: Int?
////    var productName: String?
////    var productImageUrl: String?
//    
//    private let productImageView = UIImageView()
//    
//    private let productNameLabel = UILabel().then {
//        $0.textColor = UIColor(rgb: 0x000000)
//        $0.font = .miso(size: 18, family: .extraLight)
//    }
//    
//    private let productPriceLabel = UILabel().then {
//        $0.textColor = UIColor(rgb: 0x000000)
//        $0.font = .miso(size: 18, family: .regular)
//    }
//    
//    private let productDescriptionLabel = UILabel().then {
//        $0.textColor = UIColor(rgb: 0x808080)
//        $0.font = .miso(size: 12, family: .extraLight)
//    }
//    
//    private let buyButton = UIButton().then {
//        $0.setTitle("구매하기", for: .normal)
//        $0.titleLabel?.font = .miso(size: 16, family: .extraLight)
//        $0.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
//        $0.layer.cornerRadius = 5
//        $0.clipsToBounds = true
//        $0.backgroundColor = UIColor(rgb: 0x81A895)
//    }
//    
//    override func setup() {
////        productImageView.image = UIImage(named: productImageUrl ?? "" )
////        productNameLabel.text = productName
////        productPriceLabel.text = String(productPrice ?? 0)
//        
//        
//    }
//    
//    override func addView() {
//        view.addSubviews(
//            productImageView,
//            productNameLabel,
//            productPriceLabel,
//            productDescriptionLabel,
//            buyButton
//        )
//    }
//    
//    override func setLayout() {
//        productImageView.snp.makeConstraints {
//            $0.height.equalTo(364)
//            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
//            $0.leading.trailing.equalToSuperview()
//        }
//        productNameLabel.snp.makeConstraints {
//            $0.top.equalTo(productImageView.snp.bottom).offset(40)
//            $0.leading.equalToSuperview().offset(9)
//        }
//        productPriceLabel.snp.makeConstraints {
//            $0.top.equalTo(productNameLabel.snp.bottom).offset(6)
//            $0.leading.equalTo(productNameLabel.snp.leading)
//        }
//        productDescriptionLabel.snp.makeConstraints {
//            $0.top.equalTo(productPriceLabel.snp.bottom).offset(20)
//            $0.leading.equalTo(productNameLabel.snp.leading)
//        }
//        buyButton.snp.makeConstraints {
//            $0.height.equalTo(48)
//            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview().inset(16)
//        }
//    }
//    
//}
