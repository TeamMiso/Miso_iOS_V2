import UIKit

extension UITextField {
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
            ].compactMapValues { $0 }
        )
    }
}

extension NormalTextField {
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

extension SecureTextField: UITextFieldDelegate {

//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let char = string.cString(using: String.Encoding.utf8) {
//            let isBackSpace = strcmp(char, "\\b")
//            if isBackSpace == -92 {
//                return true
//            }
//        }
//        guard textField.text!.count < 21 else { return false }
//        return true
//    }

    public func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        isSecureTextEntry = true
        return true
    }
}
