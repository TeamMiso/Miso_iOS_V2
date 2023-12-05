import SnapKit
import Then
import UIKit

final class OptionCell: UICollectionViewCell {
    static let identifier = "OptionCell"

    var mainImageView = UIImageView()

    var subImageView = UIImageView()

    var mainTitleLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0xFAFAFA)
        $0.font = .miso(size: 20, family: .extraLight)
    }

    var subTitleLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0xD0DDD7)
        $0.font = .miso(size: 15, family: .extraLight)
    }

    private let betweenView = UIView().then {
        $0.backgroundColor = UIColor(rgb: 0xD0DDD7)
    }

    var explainLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0xFFFFFF)
        $0.font = .miso(size: 20, family: .extraLight)
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        backgroundColor = UIColor(rgb: 0x81A895)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

    func addViews() {
        addSubviews(
            mainImageView,
            subImageView,
            mainTitleLabel,
            subTitleLabel,
            betweenView,
            explainLabel
        )
    }

    func setLayout() {
        mainImageView.snp.makeConstraints {
            $0.height.equalTo(230)
            $0.top.leading.trailing.equalToSuperview()
        }
        subImageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.top.equalTo(mainImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subImageView.snp.top)
            $0.leading.equalTo(subImageView.snp.trailing).offset(20)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom)
            $0.leading.equalTo(mainTitleLabel.snp.leading)
        }
        betweenView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(betweenView.snp.bottom).offset(20)
            $0.leading.equalTo(subImageView.snp.leading)
        }
    }
}
