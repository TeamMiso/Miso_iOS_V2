import UIKit
import RxKeyboard
import SnapKit
import Moya

final class LoginVC: BaseVC<AuthReactor> {

    private let containView = UIView()
    
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
    private let emailLabel = UILabel().then {
        $0.text = "Email"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let emailTextField = NormalTextField(placeholder: "  이메일").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private let passwordLabel = UILabel().then {
        $0.text = "Password"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let passwordTextField = SecureTextField(placeholder: "  비밀번호").then {
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
    
    override func bind() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.containView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
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
            containView,
            notMemberLabel,
            signupButton
        )
        containView.addSubviews(
            misoLabel,
            explainMisoLabel,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            forgotPasswordLabel,
            findPasswordButton,
            loginButton
        )
    }
    
    override func setLayout(){
        containView.snp.makeConstraints {
            $0.height.equalTo(408)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        misoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        explainMisoLabel.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(explainMisoLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview()
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
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
            $0.top.equalTo(findPasswordButton.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview()
        }
        notMemberLabel.snp.makeConstraints {
            $0.bottom.equalTo(signupButton.snp.top).inset(-8)
            $0.centerX.equalToSuperview()
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(80)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func bindView(reactor: AuthReactor) {
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
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
        }
    }
    
}
 
extension LoginVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.containView.snp.updateConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
        }
    }
}
