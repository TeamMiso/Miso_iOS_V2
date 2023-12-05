import SnapKit
import Then
import UIKit

final class ItemListCell: UICollectionViewCell {
    static let identifier = "ItemListCell"

    var productImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    var productNameLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x1C1C1E)
        $0.font = .miso(size: 15, family: .extraLight)
    }

    var productPriceLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x50555C)
        $0.font = .miso(size: 12, family: .extraLight)
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
            productImageView,
            productNameLabel,
            productPriceLabel
        )
    }

    func setLayout() {
        productImageView.snp.makeConstraints {
            $0.height.width.equalTo(164)
            $0.top.leading.trailing.equalToSuperview()
        }
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        productPriceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
    }
}
