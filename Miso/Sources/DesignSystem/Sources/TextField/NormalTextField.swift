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

extension NormalTextField: UITextFieldDelegate {

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let char = string.cString(using: String.Encoding.utf8) {
//            let isBackSpace = strcmp(char, "\\b")
//            if isBackSpace == -92 {
//                return true
//            }
//        }
//        guard textField.text!.count < 21 else { return false }
//        return true
//    }
}
