import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources

final class PurchaseHistoryVC: BaseVC<PurchaseHistoryReactor> {
    
    let purchaseHisoryListFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 8
        $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 32) , height: 80)
    }
    
    lazy var purchaseHisoryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: purchaseHisoryListFlowLayout).then {
        $0.register(PurchaseHistoryCell.self, forCellWithReuseIdentifier: PurchaseHistoryCell.identifier)
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
    
    override func bindAction(reactor: PurchaseHistoryReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in PurchaseHistoryReactor.Action.fetchPurchaseHistoryList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: PurchaseHistoryReactor) {
        reactor.state
            .map{ $0.purchaseHistoryResponse}
            .bind(to: purchaseHisoryListCollectionView.rx.items(
                cellIdentifier: PurchaseHistoryCell.identifier, cellType: PurchaseHistoryCell.self)
            ) {
                index, response, cell in
                cell.itemImageView.kf.setImage(with: URL(string: response.imageUrl))
                cell.purchaseDateLabel.text = response.createdDate
                cell.itemNameLabel.text = response.name
            }
            .disposed(by: disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
