import UIKit
import SnapKit
import Then

final class SearchVC: BaseVC<SearchReactor> {
    
    private let misoLogoImage = UIImageView().then {
        $0.image = UIImage(named: "MisoLogo-Green")
    }
    
    private let misoLabel = UILabel().then {
        $0.text = "MISO"
        $0.textColor = UIColor(rgb: 0x25D07D)
        $0.font = .miso(size: 32, family: .semiBold)
    }
    
    private let recycleButton = UIButton().then {
        $0.setImage(UIImage(systemName: "camera"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("  분리수거하기", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xBFBFBF), for: .normal)
        $0.tintColor = UIColor(rgb: 0xBFBFBF)
        $0.titleLabel?.font = .miso(size: 16, family: .medium)
    }
    
    private let searchTextField = UITextField().then {
        $0.layer.cornerRadius = 28
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(rgb: 0xBFBFBF).cgColor
        $0.backgroundColor = UIColor(rgb: 0xFFFFFF)
        $0.font = .miso(size: 14, family: .regular)
        $0.placeholder = "    재활용 쓰레기 검색하기..."
        $0.setPlaceholderColor(UIColor(rgb: 0xBFBFBF))
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xBFBFBF), for: .normal)
        $0.tintColor = UIColor(rgb: 0xBFBFBF)
    }
    
    private let recentRecyclesLabel = UILabel().then {
        $0.text = "최근 검색한 재활용 쓰레기"
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 15, family: .extraBold)
    }
    
    private let imagePicker = UIImagePickerController().then {
        $0.sourceType = .camera
        $0.cameraFlashMode = .on
        $0.allowsEditing = true
    }
    
    func presentCamera(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func setup() {
        imagePicker.delegate = self
    }
    
    override func addView() {
        view.addSubviews(
            misoLogoImage,
            misoLabel,
            recycleButton,
            searchTextField,
            searchButton,
            recentRecyclesLabel
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
        recycleButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(misoLogoImage.snp.top).offset(4)
            $0.trailing.equalToSuperview().inset(16)
        }
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.top.equalTo(misoLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        searchButton.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.top.equalTo(searchTextField.snp.top).offset(16)
            $0.trailing.equalTo(searchTextField.snp.trailing).inset(28)
        }
        recentRecyclesLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(16)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
        }
    }
    
    override func bindView(reactor: SearchReactor) {
        recycleButton.rx.tap
            .bind {
                self.presentCamera()
            }
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: SearchReactor) {
    }
}

extension SearchVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
            picker.dismiss(animated: true) {
                self.reactor.action.onNext(.cameraButtonTapped(image: imageData))
            }
        } else {
            print("이미지를 Data로 변환하는 데 실패했습니다.")
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


