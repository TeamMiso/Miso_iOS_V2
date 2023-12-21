import SnapKit
import Then
import UIKit
import RxSwift
import RxCocoa

final class ItemListCell: UICollectionViewCell {
    
    static let identifier = "ItemListCell"
    
    var itemImage = UIImageView()
    
    var itemNameLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 20, family: .semiBold)
    }
    
    var itemPointLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
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
            itemImage,
            itemNameLabel,
            itemPointLabel
        )
    }
    
    func setLayout() {
        itemImage.snp.makeConstraints {
            $0.height.equalTo(168)
            $0.top.leading.trailing.equalToSuperview()
        }
        itemNameLabel.snp.makeConstraints {
            $0.top.equalTo(itemImage.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        itemPointLabel.snp.makeConstraints {
            $0.top.equalTo(itemNameLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
    }
}
