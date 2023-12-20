import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources


final class PurchaseHistoryVC: BaseVC<MarketReactor> {
    
    let purchaseHisoryListFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 32) , height: 80)
    }
    
    lazy var purchaseHisoryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: purchaseHisoryListFlowLayout).then {
        $0.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
        $0.backgroundColor = .white
    }
    
    override func addView() {
        view.addSubview(
            purchaseHisoryListCollectionView
        )
    }
    
    override func setLayout() {
        purchaseHisoryListCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bindAction(reactor: MarketReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in MarketReactor.Action.fetchItemList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: MarketReactor) {
        reactor.state
            .map{ $0.itemListArray}
            .bind(to: purchaseHisoryListCollectionView.rx.items(
                cellIdentifier: "PurchaseHistoryCell", cellType: ItemListCell.self)
            ) {
                index, response, cell in
                cell.itemImage.kf.setImage(with: URL(string: response.imageUrl))
                cell.itemNameLabel.text = response.name
                cell.itemPointLabel.text = "\(response.price)"
                
            }
            .disposed(by: disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

