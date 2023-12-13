import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MisoTabBarVC: UITabBarController {
    
    let viewModel = CameraVM()
    
    let disposeBag = DisposeBag()
    
    private let cameraButton = UIButton().then {
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.setImage(UIImage(named: "Camera"), for: .normal)
    }
    
    func setup() {
        cameraButton.rx.tap
            .bind {
                self.presentCamera()
            }
            .disposed(by: disposeBag)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.cameraFlashMode = .on
        present(vc, animated: true, completion: nil)
    }
    
    
    func configureVC() {
        tabBar.tintColor = UIColor(rgb: 0x25D07D)
        tabBar.unselectedItemTintColor = UIColor(rgb: 0xBFBFBF)
        tabBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
    
    func setLayout() {
        cameraButton.snp.makeConstraints {
            $0.height.width.equalTo(56)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(80)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func addView() {
        view.addSubview(cameraButton)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
        setup()
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MisoTabBarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
            
            
            viewModel.uploadImage(image: imageData) { [weak self] uploadImageResults in
                DispatchQueue.main.async {
                    if let uploadImageResults = uploadImageResults {
                        
                    }
                }
            }
            
            
        } else {
            print("이미지를 Data로 변환하는 데 실패했습니다.")
        }
        picker.dismiss(animated: true)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
