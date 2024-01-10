import SnapKit
import Then
import UIKit
import RxSwift
import RxCocoa

final class PurchaseHistoryCell: UICollectionViewCell {
    
    static let identifier = "PurchaseHistoryCell"
    
    var purchaseDateLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    
    var itemNameLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 20, family: .semiBold)
    }
    
    var itemImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubviews(
            purchaseDateLabel,
            itemNameLabel,
            itemImageView
        )
    }
    
    func setLayout() {
        purchaseDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
        }
        itemNameLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseDateLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
        itemImageView.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
        }
    }
}

