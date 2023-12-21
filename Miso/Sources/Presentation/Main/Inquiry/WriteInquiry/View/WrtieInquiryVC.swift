import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources
import PhotosUI

final class WriteInquiryVC: BaseVC<WriteInquiryReactor> {
    
    var inquiryImage: UIImage? = nil
    
    lazy var configuration: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        return config
    }()
    
    lazy var picker: PHPickerViewController = {
        return PHPickerViewController(configuration: self.configuration)
    }()
    
    func presentPhotoLibray(){
        present(picker, animated: true, completion: nil)
    }
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    lazy var rightButton = UIBarButtonItem().then {
        $0.title = "문의하기"
        $0.tintColor = UIColor(rgb: 0x25D07D)
    }
    
    private let titleTextField = UITextField().then {
        $0.font = .miso(size: 32, family: .extraBold)
        $0.setPlaceholderColor(UIColor(rgb: 0xBFBFBF))
        $0.textColor = UIColor(rgb: 0x000000)
        $0.placeholder = "문의 제목 쓰기"
    }
    
    private let imageButton = UIButton().then {
        $0.backgroundColor = UIColor(rgb: 0xBFBFBF)
        $0.setImage(UIImage(named: "uploadImage"), for: .normal)
    }
    
    private let placeholderLabel = UILabel().then {
        $0.text = "문의 내용:"
        $0.textColor = UIColor(rgb: 0xBFBFBF)
        $0.font = .miso(size: 15, family: .semiBold)
    }
    
    private let contentTextView = UITextView().then {
        $0.font = .miso(size: 15, family: .semiBold)
        $0.textColor = UIColor(rgb: 0x000000)
    }
    
    
    override func setup() {
        navigationItem.title = "문의하기"
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(rgb: 0x3484DB)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = rightButton
        
        picker.delegate = self
    }
    
    override func addView() {
        scrollView.addSubviews(
            titleTextField,
            imageButton,
            placeholderLabel,
            contentTextView
        )
        view.addSubview(
            scrollView
        )
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        titleTextField.snp.makeConstraints {
            $0.height.equalTo((bound.height) / 15.214)
            $0.width.equalTo(bound.width)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        imageButton.snp.makeConstraints {
            $0.height.equalTo((bound.height) / 3.55)
            $0.width.equalTo(bound.width)
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(imageButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        contentTextView.snp.makeConstraints {
            $0.height.equalTo(272)
            $0.width.equalTo(bound.width)
            $0.top.equalTo(placeholderLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    override func bindView(reactor: WriteInquiryReactor) {
        imageButton.rx.tap
            .bind {
                self.presentPhotoLibray()
            }
            .disposed(by: disposeBag)
            
        rightButton.rx.tap
            .map {  WriteInquiryReactor.Action.writeInquiryComplished(
                title: self.titleTextField.text ?? "",
                image: self.inquiryImage!,
                content: self.contentTextView.text ?? "")}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}

extension WriteInquiryVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async { [self] in
                    inquiryImage = image as! UIImage
                    self.imageButton.setImage(image as! UIImage, for: .normal)
                }
            }
        } else {
        }
    }
}
