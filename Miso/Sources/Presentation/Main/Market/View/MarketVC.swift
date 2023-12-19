import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class MarketVC: BaseVC<MarketReactor> {
    
    var itemListArray: [SearchRecyclablesListResponse] = []
    
    private let misoLogoImage = UIImageView().then {
        $0.image = UIImage(named: "MisoLogo-Green")
    }
    
    private let misoLabel = UILabel().then {
        $0.text = "MISO"
        $0.textColor = UIColor(rgb: 0x25D07D)
        $0.font = .miso(size: 32, family: .semiBold)
    }
    
    private let purchaseHistoryButton = UIButton().then {
        $0.setImage(UIImage(systemName: "shoppingbag"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("  구매내역", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xBFBFBF), for: .normal)
        $0.tintColor = UIColor(rgb: 0xBFBFBF)
        $0.titleLabel?.font = .miso(size: 16, family: .medium)
    }
    
    let recycleListFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    lazy var recycleListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recycleListFlowLayout).then {
        $0.register(RecycleListCell.self, forCellWithReuseIdentifier: RecycleListCell.identifier)
        $0.backgroundColor = .white
    }
    
    override func setup() {
        recycleListCollectionView.delegate = self
        recycleListCollectionView.dataSource = self
    }
    
    override func addView() {
        view.addSubviews(
            misoLogoImage,
            misoLabel,
            purchaseHistoryButton,
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
        purchaseHistoryButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(misoLogoImage.snp.top).offset(4)
            $0.trailing.equalToSuperview().inset(16)
        }
        recycleListCollectionView.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bindView(reactor: MarketReactor) {
        reactor.action.onNext(.fetchItemList)
    }
    
    override func bindState(reactor: MarketReactor) {
//        reactor.state
//            .map{ $0.itemListArray}
//            .subscribe(onNext: { itemListArray in
//                self.itemListArray.append(itemListArray)
//            })
//            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}


extension MarketVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 16
        
        let width: CGFloat = (UIScreen.main.bounds.width - 32 - itemSpacing)/2
        return CGSize(width: width, height: 232)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecycleListCell.identifier, for: indexPath)
        
        
        cell.backgroundColor = .white
        
        return cell
    }
}
