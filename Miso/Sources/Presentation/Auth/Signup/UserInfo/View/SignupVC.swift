import UIKit
import RxKeyboard
import SnapKit

final class SignupVC: BaseVC<AuthReactor> {
    
    private let textFieldsView = UIView()
    
    private let emailLabel = UILabel().then {
        $0.text = "Email"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let emailTextField = NormalTextField(placeholder: "이메일").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private let passwordLabel = UILabel().then {
        $0.text = "Password"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let passwordTextField = SecureTextField(placeholder: "비밀번호").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private let confirmPasswordLabel = UILabel().then {
        $0.text = "confirmPassword"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let checkPasswordTextField = SecureTextField(placeholder: "비밀번호 확인").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private lazy var signupButton = NextStepButton().then {
        $0.setTitle("회원가입", for: .normal)
    }
    
    func showKeyboard() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(onNext: { keyboardVisibleHeight in
                self.textFieldsView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
                }
                self.signupButton.snp.updateConstraints {
                    $0.top.equalTo(self.checkPasswordTextField.snp.bottom).offset(48)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    override func setup() {
        let backBarButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(rgb: 0x3484DB)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar
        self.navigationItem.title = "회원가입"
        
        showKeyboard()
    }
    
    override func addView() {
        view.addSubviews(
            textFieldsView,
            signupButton
        )
        textFieldsView.addSubviews(
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            confirmPasswordLabel,
            checkPasswordTextField
        )
    }
    
    override func setLayout(){
        textFieldsView.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(bound.height / 9.68)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(8)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(passwordLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        confirmPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(8)
        }
        checkPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(confirmPasswordLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(checkPasswordTextField.snp.bottom).offset(88)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func bindView(reactor: AuthReactor) {
        signupButton.rx.tap
            .map { AuthReactor.Action.signupIsCompleted (
                email: self.emailTextField.text ?? "",
                password: self.passwordTextField.text ?? "",
                passwordCheck: self.checkPasswordTextField.text ?? ""
            )}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldsView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(88)
        }
        signupButton.snp.updateConstraints {
            $0.top.equalTo(self.checkPasswordTextField.snp.bottom).offset(88)
        }
    }
}

extension SignupVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textFieldsView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(88)
        }
        signupButton.snp.updateConstraints {
            $0.top.equalTo(self.checkPasswordTextField.snp.bottom).offset(48)
        }
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
        textFieldsView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(bound.height / 9.68)
        }
    }
}
