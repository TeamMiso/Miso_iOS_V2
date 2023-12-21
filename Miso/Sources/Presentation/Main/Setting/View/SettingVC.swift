import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources


final class SettingVC: BaseVC<SettingReactor> {
    
    private let misoLogoImage = UIImageView().then {
        $0.image = UIImage(named: "MisoLogo-Green")
    }
    
    private let misoLabel = UILabel().then {
        $0.text = "MISO"
        $0.textColor = UIColor(rgb: 0x25D07D)
        $0.font = .miso(size: 32, family: .semiBold)
    }
    
    private let userEmailLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 20, family: .regular)
    }
    
    private let loggedInLabel = UILabel().then {
        $0.text = " 에 로그인됨"
        $0.textColor = UIColor(rgb: 0xBFBFBF)
        $0.font = .miso(size: 20, family: .semiBold)
    }
    
    private let pushNotificationLabel = UILabel().then {
        $0.text = "푸시 알람 켜기"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .semiBold)
    }
    
    private let notificationInfoLabel = UILabel().then {
        $0.text = "문의사항에 답변이 오면 알려드려요"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    
    private let togggleButton = UISwitch()
    
    private let logoutButton = UIButton().then {
        $0.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("  로그아웃", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xDB3734), for: .normal)
        $0.tintColor = UIColor(rgb: 0xDB3734)
        $0.titleLabel?.font = .miso(size: 16, family: .extraBold)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(rgb: 0xDB3734).cgColor
        $0.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
    
    override func setup() {
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(rgb: 0x3484DB)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func addView() {
        view.addSubviews(
            misoLogoImage,
            misoLabel,
            userEmailLabel,
            loggedInLabel,
            pushNotificationLabel,
            notificationInfoLabel,
            togggleButton,
            logoutButton
        )
    }
    
    override func setLayout() {
        misoLogoImage.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        misoLabel.snp.makeConstraints {
            $0.top.equalTo(misoLogoImage.snp.top).offset(4)
            $0.leading.equalTo(misoLogoImage.snp.trailing)
        }
        userEmailLabel.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        loggedInLabel.snp.makeConstraints {
            $0.top.equalTo(userEmailLabel.snp.top)
            $0.leading.equalTo(userEmailLabel.snp.trailing)
        }
        pushNotificationLabel.snp.makeConstraints {
            $0.top.equalTo(userEmailLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        notificationInfoLabel.snp.makeConstraints {
            $0.top.equalTo(pushNotificationLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
        }
        togggleButton.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(56)
            $0.top.equalTo(userEmailLabel.snp.bottom).offset(36)
            $0.trailing.equalToSuperview().inset(16)
        }
        logoutButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(bound.width - 32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func bindView(reactor: SettingReactor) {
        
    }
    
    override func bindAction(reactor: SettingReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in SettingReactor.Action.fetchUserInfoResponse }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: SettingReactor) {
        reactor.state
            .map { $0.userInfoResponse }
            .subscribe(onNext: { userInfoResponse in
                self.userEmailLabel.text = userInfoResponse?.email
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
