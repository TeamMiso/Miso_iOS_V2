import UIKit

public final class SecureTextField: UITextField {
    var passwordToggleButton = UIButton(type: .custom)

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

        isSecureTextEntry = true
        setPasswordToggleButtonImage()
    }

    func setPasswordToggleButtonImage() {
        passwordToggleButton = UIButton(primaryAction: UIAction(handler: { [self] _ in
            isSecureTextEntry.toggle()
            self.passwordToggleButton.isSelected.toggle()
        }))

        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear

        passwordToggleButton.setImage(UIImage(systemName: "eye")?.withTintColor(UIColor(rgb: 0x999999), renderingMode: .alwaysOriginal), for: .normal)

        passwordToggleButton.setImage(UIImage(systemName: "eye.slash")?.withTintColor(UIColor(rgb: 0x999999), renderingMode: .alwaysOriginal), for: .selected)

        passwordToggleButton.configuration = buttonConfiguration
        passwordToggleButton.isSelected.toggle()

        rightView = passwordToggleButton
        rightViewMode = .always
    }
}
