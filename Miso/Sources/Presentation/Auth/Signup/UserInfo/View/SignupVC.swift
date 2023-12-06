import UIKit
import RxKeyboard
import SnapKit

final class SignupVC: BaseVC {
    
    private let containView = UIView()
    
    private let emailLabel = UILabel().then {
        $0.text = "Email"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let emailTextField = NormalTextField(placeholder: ".  이메일").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private let passwordLabel = UILabel().then {
        $0.text = "Password"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let passwordTextField = SecureTextField(placeholder: ".  비밀번호").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private let confirmPasswordLabel = UILabel().then {
        $0.text = "confirmPassword"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    private let confirmPasswordTextField = SecureTextField(placeholder: ".  비밀번호 확인").then {
        $0.font = .miso(size: 15, family: .regular)
    }
    private lazy var signupButton = NextStepButton().then {
        $0.setTitle("회원가입", for: .normal)
//        $0.isEnabled = false
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func showKeyboard() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(onNext: { keyboardVisibleHeight in
                self.signupButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight-24)
                }
                self.containView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
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
        self.navigationItem.title = "회원가입"
        
        showKeyboard()
    }
    
    override func addView() {
        view.addSubviews(
            containView
        )
        containView.addSubviews(
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            confirmPasswordLabel,
            confirmPasswordTextField,
            signupButton
        )
    }
    
    override func setLayout(){
        containView.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(88)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
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
        confirmPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        confirmPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(confirmPasswordLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(208)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(108)
        }
        signupButton.snp.updateConstraints {
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

extension SignupVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(88)
        }
        signupButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(208)
        }
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
        containView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(88)
        }
        signupButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(208)
        }
    }
}

