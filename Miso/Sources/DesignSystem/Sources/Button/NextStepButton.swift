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
        titleLabel?.font = .miso(size: 20, family: .extraLight)
        setTitleColor(UIColor(rgb: 0xE5F0EC), for: .normal)
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = UIColor(rgb: 0x81A895)
    }
}
