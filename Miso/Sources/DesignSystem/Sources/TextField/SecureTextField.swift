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
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgb: 0xBFBFBF).cgColor
        backgroundColor = UIColor(rgb: 0xFFFFFF)
        font = .miso(size: 14, family: .regular)
        setPlaceholderColor(UIColor(rgb: 0xBFBFBF))
        
        isSecureTextEntry = true
        setPasswordToggleButtonImage()
    }
    
    func setPasswordToggleButtonImage() {
        passwordToggleButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            isSecureTextEntry.toggle()
            self.passwordToggleButton.isSelected.toggle ()
        }))
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        
        passwordToggleButton.setImage (UIImage (systemName: "eye")?.withTintColor(UIColor(rgb: 0x999999), renderingMode: .alwaysOriginal), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash")?.withTintColor(UIColor(rgb: 0x999999), renderingMode: .alwaysOriginal), for: .selected)
        
        passwordToggleButton.configuration = buttonConfiguration
        passwordToggleButton.isSelected.toggle()
        
        rightView = passwordToggleButton
        rightViewMode = .always
    }
}


