import SnapKit
import Then
import UIKit
import RxSwift
import RxCocoa

final class RecycleListCell: UICollectionViewCell {
    
    var cellDisposeBag = DisposeBag()
    
    static let identifier = "RecycleListCell"
    
    var recycleNameLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .semiBold)
    }
    
    var recycleTypeLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .semiBold)
    }

    var recycleMethodLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }

    var recycleImage = UIImageView().then {
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
            recycleNameLabel,
            recycleTypeLabel,
            recycleMethodLabel,
            recycleImage
        )
    }

    func setLayout() {
        recycleNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview()
        }
        recycleTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(recycleNameLabel.snp.trailing).offset(4)
        }
        recycleMethodLabel.snp.makeConstraints {
            $0.top.equalTo(recycleNameLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(recycleImage.snp.leading).inset(-16)
        }
        recycleImage.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
        }
    }
}
