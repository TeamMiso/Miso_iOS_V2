import RxCocoa
import RxFlow
import UIKit

final class LoginVC: BaseVC<LoginVM> {
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        MisoStep.loginIsRequired
    }

    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "LoginBackground")
    }

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Logo")
    }

    private let misoLabel = UILabel().then {
        $0.text = "\"미소\""
        $0.textColor = UIColor(rgb: 0xFAFAFA)
        $0.textAlignment = .center
        $0.font = .miso(size: 24, family: .extraLight)
    }

    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(rgb: 0xE5F0EC)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }

    private let vcNameLabel = UILabel().then {
        $0.text = "Log In"
        $0.textColor = UIColor(rgb: 0x416A36)
        $0.textAlignment = .center
        $0.font = .miso(size: 30, family: .extraLight)
    }

    private let emailLabel = UILabel().then {
        $0.text = "Email"
        $0.textColor = UIColor(rgb: 0x292929)
        $0.textAlignment = .center
        $0.font = .miso(size: 13, family: .extraLight)
    }

    private let emailTextfield = NormalTextField(placeholder: "  이메일을 입력해주세요").then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }

    private let passwordLabel = UILabel().then {
        $0.text = "Password"
        $0.textColor = UIColor(rgb: 0x292929)
        $0.textAlignment = .center
        $0.font = .miso(size: 13, family: .extraLight)
    }

    private let passwordTextfield = SecureTextField(placeholder: "  비밀번호를 입력해주세요").then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }

    private let getAuthNumberButton = NextStepButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.isEnabled = false
//        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    private let accountAskLabel = UILabel().then {
        $0.text = "계정이 없으신가요?"
        $0.textColor = UIColor(rgb: 0x808080)
        $0.font = .miso(size: 12, family: .extraLight)
    }

    private let gotoSignupButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .miso(size: 12, family: .light)
        $0.setTitleColor(UIColor(rgb: 0x81A895), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setup() {
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }

    override func addView() {
        view.addSubviews(
            backgroundImageView,
            logoImageView,
            misoLabel,
            backgroundView,
            vcNameLabel,

            emailLabel,
            emailTextfield,

            passwordLabel,
            passwordTextfield,

            getAuthNumberButton,
            accountAskLabel,
            gotoSignupButton
        )
    }

    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints {
            $0.height.width.equalTo(70)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
        }
        misoLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        vcNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.backgroundView.snp.top).offset(35)
            $0.centerX.equalToSuperview()
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(vcNameLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(32)
        }
        emailTextfield.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(emailLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextfield.snp.bottom).offset(22)
            $0.leading.equalTo(emailLabel)
        }
        passwordTextfield.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(passwordLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        getAuthNumberButton.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.top.equalTo(passwordTextfield.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        accountAskLabel.snp.makeConstraints {
            $0.top.equalTo(getAuthNumberButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(116)
        }
        gotoSignupButton.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.top.equalTo(accountAskLabel.snp.top)
            $0.leading.equalTo(accountAskLabel.snp.trailing).offset(4)
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextfield {
            emailTextfield.layer.borderColor = UIColor(rgb: 0x4C53FF).cgColor
            emailTextfield.layer.borderWidth = 1
        } else {
            passwordTextfield.layer.borderColor = UIColor(rgb: 0x4C53FF).cgColor
            passwordTextfield.layer.borderWidth = 1
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextfield {
            emailTextfield.layer.borderWidth = 0
        } else {
            passwordTextfield.layer.borderWidth = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
