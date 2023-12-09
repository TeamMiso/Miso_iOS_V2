import UIKit

public final class NextStepButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        titleLabel?.font = .miso(size: 16, family: .extraBold)
        setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = UIColor(rgb: 0x25D07D)
    }
}
