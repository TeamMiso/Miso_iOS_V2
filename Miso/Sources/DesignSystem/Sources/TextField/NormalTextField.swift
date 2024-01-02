import UIKit

public final class NormalTextField: UITextField{
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgb: 0xBFBFBF).cgColor
        backgroundColor = UIColor(rgb: 0xFFFFFF)
        font = .miso(size: 14, family: .regular)
        setPlaceholderColor(UIColor(rgb: 0xBFBFBF))
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        leftViewMode = .always
    }
    
}
