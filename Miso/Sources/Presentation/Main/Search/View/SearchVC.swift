import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class SearchVC: BaseVC<SearchReactor> {
    
    var recentSearchArray: [SearchRecyclablesListResponse] = []

    let dbHelper = SearchDataDB.shared
    
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
    
    private let imagePicker = UIImagePickerController().then {
        $0.sourceType = .camera
        $0.cameraFlashMode = .auto
        $0.allowsEditing = true
    }
    
    private let searchTextField = UITextField().then {
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(rgb: 0xBFBFBF).cgColor
        $0.backgroundColor = UIColor(rgb: 0xFFFFFF)
        $0.font = .miso(size: 14, family: .regular)
        $0.textColor = UIColor(rgb: 0x000000)
        $0.placeholder = "재활용 쓰레기 검색하기..."
        $0.setPlaceholderColor(UIColor(rgb: 0xBFBFBF))
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 48))
        $0.leftViewMode = .always
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
    
    var recycleNameLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .semiBold)
    }
    
    var recycleTypeLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .semiBold)
    }
    
    var recycleMethodLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 12, family: .regular)
    }
    
    var recycleImage = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let toDetailButton = UIButton()
    
    let recycleListFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    lazy var recycleListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recycleListFlowLayout).then {
        $0.register(RecycleListCell.self, forCellWithReuseIdentifier: RecycleListCell.identifier)
        $0.backgroundColor = .white
    }
    
    func presentCamera(){
        present(imagePicker, animated: true, completion: nil)
    }

    override func setup() {
        imagePicker.delegate = self
        searchTextField.delegate = self
        recycleListCollectionView.delegate = self
        recycleListCollectionView.dataSource = self

        
        toDetailButton.isHidden = true
        recentSearchArray = dbHelper.readData()
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(rgb: 0x3484DB)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    
    }
    
    override func addView() {
        toDetailButton.addSubviews(
            recycleNameLabel,
            recycleTypeLabel,
            recycleMethodLabel,
            recycleImage
        )
        view.addSubviews(
            misoLogoImage,
            misoLabel,
            recycleButton,
            searchTextField,
            searchButton,
            recentRecyclesLabel,
            toDetailButton,
            recycleListCollectionView
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
            $0.height.equalTo(48)
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
        recycleNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        recycleTypeLabel.snp.makeConstraints {
            $0.top.equalTo(recycleNameLabel.snp.top)
            $0.leading.equalTo(recycleNameLabel.snp.trailing).offset(4)
        }
        recycleMethodLabel.snp.makeConstraints {
            $0.top.equalTo(recycleNameLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(recycleImage.snp.leading).inset(16)
        }
        recycleImage.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        toDetailButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(recentRecyclesLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        recycleListCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentRecyclesLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bindView(reactor: SearchReactor) {
        recycleButton.rx.tap
            .bind {
                self.presentCamera()
            }
            .disposed(by: disposeBag)
        searchTextField.rx.text
            .distinctUntilChanged()
            .map { searchText in
                if let searchText = searchText, !searchText.isEmpty {
                    return SearchReactor.Action.searchRecycle(searchText: searchText)
                } else {
                    return nil
                }
            }
            .compactMap { $0 }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        toDetailButton.rx.tap
            .map { [weak self] _ -> SearchReactor.State? in
                return self?.reactor?.currentState
            }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] currentState in
                guard let self = self else { return }
                let title = currentState.title
                let recyclablesType = currentState.recyclablesType
                let recycleMethod = currentState.recycleMethod
                let imageUrl = currentState.imageUrl
                
                self.storeSearchData(
                    title: title,
                    imageUrl: imageUrl,
                    recycleMethod: recycleMethod,
                    recyclablesType: recyclablesType
                )
                
                self.reactor?.action.onNext(.detailButtonTapped(recycleType: recyclablesType))
            })
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: SearchReactor) {
        
        reactor.state
            .map { $0.title }
            .subscribe(onNext: { title in
                self.recycleNameLabel.text = title
            })
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.recyclablesType }
            .subscribe(onNext: { recyclablesType in
                self.recycleTypeLabel.text = recyclablesType
            })
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.recycleMethod }
            .subscribe(onNext: { recycleMethod in
                self.recycleMethodLabel.text = recycleMethod
            })
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.imageUrl }
            .subscribe(onNext: { imageURL in
                self.recycleImage.kf.setImage(with: URL(string: imageURL))
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        print("viewWillAppear \(recentSearchArray.count)")
    }
    
    func storeSearchData(title: String, imageUrl: String, recycleMethod: String, recyclablesType: String) {
        dbHelper.insertData(title: title, imageUrl: imageUrl, recycleMethod: recycleMethod, recyclablesType: recyclablesType)
    }
    
   
}

extension SearchVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
           let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
            picker.dismiss(animated: true) {
                self.reactor?.action.onNext(.cameraButtonTapped(imageData: imageData, originalImage: pickedImage))
            }
        } else {
            print("이미지를 Data로 변환하는 데 실패했습니다.")
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reversedArray = recentSearchArray.reversed()
        let reversedIndex = reversedArray.index(reversedArray.startIndex, offsetBy: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecycleListCell.identifier, for: indexPath)
        
        if let cell = cell as? RecycleListCell {
            cell.recycleNameLabel.text = reversedArray[reversedIndex].title
            cell.recycleTypeLabel.text = reversedArray[reversedIndex].recyclablesType
            cell.recycleMethodLabel.text = reversedArray[reversedIndex].recycleMethod
            cell.recycleImage.kf.setImage(with: URL(string: reversedArray[reversedIndex].imageUrl))
        }
        
        cell.backgroundColor = .white
        
        return cell
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recentRecyclesLabel.text = "검색 결과"
        
        if searchTextField.text?.count == 0 {
            self.recycleNameLabel.text = "검색결과가 없습니다."
        }
        
        recycleListCollectionView.isHidden = true
        toDetailButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        recentRecyclesLabel.text = "최근 검색한 재활용 쓰레기"
        searchTextField.text = ""
        
        recycleNameLabel.text = ""
        recycleTypeLabel.text = ""
        recycleMethodLabel.text = ""
        recycleImage.image = UIImage(named: "")
        
        toDetailButton.isHidden = true
        recycleListCollectionView.isHidden = false
        
        self.recentSearchArray = dbHelper.readData()
        self.recycleListCollectionView.reloadData()
    }
}
