import UIKit

public final class NormalTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupView() {
        backgroundColor = UIColor(rgb: 0xFAFAFA)
        font = .miso(size: 13, family: .extraLight)
        setPlaceholderColor(UIColor(rgb: 0x808080))

        let lockImageView = UIImageView(image: UIImage(named: "Mail"))

        leftView = lockImageView
        leftViewMode = .unlessEditing
    }
}
