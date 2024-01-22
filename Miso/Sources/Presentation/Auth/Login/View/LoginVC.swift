import UIKit
import RxKeyboard
import SnapKit
import Moya

final class LoginVC: BaseVC<AuthReactor> {
    
    var misoIntroStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    private let misoLabel = UILabel().then {
        $0.text = "미소"
        $0.textColor = UIColor(rgb: 0x25D07D)
        $0.font = .miso(size: 32, family: .extraBold)
    }
    private let explainMisoLabel = UILabel().then {
        $0.text = "환경을 웃음으로 바꾸다 :)"
        $0.textColor = UIColor(rgb: 0xBFBFBF)
        $0.font = .miso(size: 20, family: .regular)
    }
    private let textFieldView = UIView()
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
    private let forgotPasswordLabel = UILabel().then {
        $0.text = "비밀번호를 잊으셨나요?"
        $0.textColor = UIColor(rgb: 0xBFBFBF)
        $0.font = .miso(size: 12, family: .regular)
    }
    private lazy var findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0x3484DB), for: .normal)
        $0.titleLabel?.font = .miso(size: 12, family: .regular)
    }
    private lazy var loginButton = NextStepButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.isUserInteractionEnabled = true
    }
    private let notMemberLabel = UILabel().then {
        $0.text = "-------------------------- 회원이 아니신가요? --------------------------"
        $0.textColor = UIColor(rgb: 0xBFBFBF)
        $0.font = .miso(size: 12, family: .regular)
    }
    private lazy var signupButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0x3484DB), for: .normal)
        $0.titleLabel?.font = .miso(size: 15, family: .regular)
    }
    
    override func setup() {
        let backBarButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(rgb: 0x3484DB)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func addView() {
        view.addSubviews(
            misoIntroStackview,
            textFieldView,
            loginButton,
            notMemberLabel,
            signupButton
        )
        misoIntroStackview.addSubviews(
            misoLabel,
            explainMisoLabel
        )
        textFieldView.addSubviews(
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            forgotPasswordLabel,
            findPasswordButton
        )
    }
    
    override func setLayout(){
        misoIntroStackview.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(bound.height / 15.2)
            $0.leading.equalToSuperview().offset(16)
        }
        misoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        explainMisoLabel.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
        textFieldView.snp.makeConstraints {
            $0.height.equalTo(184)
            $0.top.equalTo(misoIntroStackview.snp.bottom).offset(bound.height / 7.1)
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
        forgotPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        findPasswordButton.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordLabel.snp.top)
            $0.trailing.equalToSuperview()
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(notMemberLabel.snp.top).offset(-(bound.height / 10.65))
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        notMemberLabel.snp.makeConstraints {
            $0.bottom.equalTo(signupButton.snp.top).inset(-8)
            $0.centerX.equalToSuperview()
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(bound.height / 21.3)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func bindView(reactor: AuthReactor) {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.textFieldView.snp.updateConstraints {
                    $0.top.equalTo(self.misoIntroStackview.snp.bottom).offset(self.bound.height / 21.3)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        loginButton.rx.tap
            .map {  AuthReactor.Action.loginIsCompleted (
                email: self.emailTextField.text ?? "",
                password: self.passwordTextField.text ?? ""
            )}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        signupButton.rx.tap
            .map{ AuthReactor.Action.signupIsRequired }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textFieldView.snp.updateConstraints {
            $0.top.equalTo(misoIntroStackview.snp.bottom).offset(bound.height / 7.1)
        }
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailTextField.layer.borderColor = UIColor(rgb: 0x25D07D).cgColor
        case passwordTextField:
            passwordTextField.layer.borderColor = UIColor(rgb: 0x25D07D).cgColor
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case emailTextField:
            emailTextField.layer.borderColor = UIColor(rgb: 0xBFBFBF).cgColor
        case passwordTextField:
            passwordTextField.layer.borderColor = UIColor(rgb: 0xBFBFBF).cgColor
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.textFieldView.snp.updateConstraints {
                $0.top.equalTo(self.misoIntroStackview.snp.bottom).offset(self.bound.height / 7.1)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
        textFieldView.snp.updateConstraints {
            $0.top.equalTo(misoIntroStackview.snp.bottom).offset(bound.height / 7.1)
        }
    }
}
