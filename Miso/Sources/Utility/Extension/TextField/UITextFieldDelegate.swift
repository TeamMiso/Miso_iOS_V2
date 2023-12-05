import UIKit

public extension UITextField {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        endEditing(true)
    }
}
