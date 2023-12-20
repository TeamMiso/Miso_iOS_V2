import UIKit
import Then
import SnapKit
import AEOTPTextField
import RxSwift
import RxKeyboard
import RxCocoa

final class CertificationVC: BaseVC<AuthReactor> {
    
    var btnVerifyBottomConstraint = 10
    
    var buttonBottomConstraint: NSLayoutConstraint?
    
    private let certificationNumberTextField = AEOTPTextField().then{
        $0.otpFont = .miso(size: 32, family: .semiBold)
        $0.otpTextColor = UIColor(rgb: 0x25D07D)
        $0.otpCornerRaduis = 8
        $0.configure(with: 4)
    }
    
    override func setup() {
        certificationNumberTextField.otpDelegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "인증번호 입력"
    }
    
    override func addView() {
        view.addSubview(certificationNumberTextField)
    }
    
    override func setLayout() {
        self.certificationNumberTextField.snp.makeConstraints{
            $0.height.equalTo(96)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(208)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.certificationNumberTextField.snp.updateConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(208)
        }
    }

}

extension CertificationVC: AEOTPTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func didUserFinishEnter(the code: String) {
        print(code)
        reactor?.action.onNext(.certificationIsCompleted(randomKey: code))
    }
}
