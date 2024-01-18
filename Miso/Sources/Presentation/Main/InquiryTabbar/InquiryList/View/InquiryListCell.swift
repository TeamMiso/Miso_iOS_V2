import SnapKit
import Then
import UIKit
import RxSwift
import RxCocoa

final class InquiryListCell: UICollectionViewCell {
    
    static let identifier = "InquiryListCell"
    
    var dateAndStatusStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    var requestDateLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    
    var statusLabel = UILabel().then {
        $0.font = .miso(size: 12, family: .regular)
    }
    
    var itemTitleLabel = UILabel().then {
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
        [
            requestDateLabel,
            statusLabel
        ].forEach{
            dateAndStatusStackview.addArrangedSubview($0)
        }
        addSubviews(
            dateAndStatusStackview,
            itemTitleLabel,
            itemImageView
        )
    }
    
    func setLayout() {
        dateAndStatusStackview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
        }
        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateAndStatusStackview.snp.bottom)
            $0.leading.equalToSuperview()
        }
        itemImageView.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
        }
    }
}


