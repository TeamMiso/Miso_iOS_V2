import UIKit
import RxKeyboard
import SnapKit

final class LoginVC: BaseVC {
    
    let viewModel = LoginVM()
    
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
    private lazy var forgotPasswordButton = UIButton().then {
        $0.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xBFBFBF), for: .normal)
        $0.titleLabel?.font = .miso(size: 12, family: .regular)
        $0.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    private lazy var findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0x3484DB), for: .normal)
        $0.titleLabel?.font = .miso(size: 12, family: .regular)
        $0.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    private lazy var loginButton = NextStepButton().then {
        $0.setTitle("로그인", for: .normal)
//        $0.isEnabled = false
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    private let notMemberLabel = UILabel().then {
        $0.text = "-------------------------- 회원이 아니신가요? --------------------------"
        $0.textColor = UIColor(rgb: 0xBFBFBF)
        $0.font = .miso(size: 12, family: .regular)
    }
    private lazy var signinButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0x3484DB), for: .normal)
        $0.titleLabel?.font = .miso(size: 15, family: .regular)
        $0.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    func showKeyBoard() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(onNext: { keyboardVisibleHeight in
                UIView.animate(withDuration: 1.0) {
                    self.loginButton.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight-24)
                    }
                    self.containView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
                    }
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
        
        showKeyBoard()
    }
    
    override func addView() {
        view.addSubviews(
            notMemberLabel,
            signinButton,
            containView
        )
        containView.addSubviews(
            misoLabel,
            explainMisoLabel,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            forgotPasswordButton,
            findPasswordButton,
            loginButton
        )
    }
    
    override func setLayout(){
        containView.snp.makeConstraints {
            $0.height.equalTo(304)
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
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        findPasswordButton.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordButton.snp.top)
            $0.trailing.equalToSuperview()
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(208)
        }
        notMemberLabel.snp.makeConstraints {
            $0.bottom.equalTo(signinButton.snp.top).inset(-8)
            $0.centerX.equalToSuperview()
        }
        signinButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(80)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
        }
        loginButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(152)
        }
    }
    
    @objc func loginButtonTapped(_ sender: UIButton){
        
    }
    
    @objc func findPasswordButtonTapped(_ sender: UIButton){
        print("비밀번호 찾기 버튼 클릭")
        //        let vc = FindPasswordVC()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signupButtonTapped(_ sender: UIButton){
        print("회원가입 버튼 클릭")
        let vc = SignupVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
        }
        loginButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(208)
        }
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
        }
        loginButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(208)
        }
    }
}
