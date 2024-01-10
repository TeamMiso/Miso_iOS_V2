import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources


final class MarketVC: BaseVC<MarketReactor> {
    
    private let misoLogoImage = UIImageView().then {
        $0.image = UIImage(named: "MisoLogo-Green")
    }
    
    private let misoLabel = UILabel().then {
        $0.text = "Miso"
        $0.textColor = UIColor(rgb: 0x25D07D)
        $0.font = .miso(size: 32, family: .semiBold)
    }
    
    private let purchaseHistoryButton = UIButton().then {
        $0.setImage(UIImage(systemName: "bag"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("  구매내역", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xBFBFBF), for: .normal)
        $0.tintColor = UIColor(rgb: 0xBFBFBF)
        $0.titleLabel?.font = .miso(size: 16, family: .medium)
    }
    
    let itemListFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: 232)
    }
    
    lazy var itemListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemListFlowLayout).then {
        $0.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
        $0.backgroundColor = .white
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
            purchaseHistoryButton,
            itemListCollectionView
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
        itemListCollectionView.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bindAction(reactor: MarketReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in MarketReactor.Action.fetchItemList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        purchaseHistoryButton.rx.tap
            .map { Reactor.Action.purchaseHistoryButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: MarketReactor) {
        reactor.state
            .map{ $0.itemListArray}
            .bind(to: itemListCollectionView.rx.items(
                cellIdentifier: "ItemListCell", cellType: ItemListCell.self)
            ) {
                index, response, cell in
                cell.itemImage.kf.setImage(with: URL(string: response.imageUrl))
                cell.itemNameLabel.text = response.name
                cell.itemPointLabel.text = "\(response.price) Point"
                
            }
            .disposed(by: disposeBag)
    }
    
    override func bindView(reactor: MarketReactor) {
       purchaseHistoryButton.rx.tap
            .map {  MarketReactor.Action.fetchItemList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        itemListCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let row = indexPath.row
                
                guard let currentState = self.reactor?.currentState else { return }
                let id = "\(currentState.itemListArray[row].id)"
                self.reactor?.action.onNext(.itemDetailTapped(productId: id))
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
