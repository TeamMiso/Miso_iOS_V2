import UIKit
import Kingfisher

final class ItemDetailVC: BaseVC<ItemDetailReactor> {
    
    var itemTitle: String = ""
    var imageURL: String = ""
    var content: String = ""
    var point: Int = 0
    var id: Int = 0
    var buyText: String = ""
    var currentPoint: Int = 0
    
    private let itemImageView = UIImageView()
    
    private let contentLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
        $0.numberOfLines = 0
    }
    
    private let buyButton = NextStepButton()
    
    override func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private let currentPointLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0xBFBFBF)
    }
    
    private let currentPointImageView = UIImageView().then {
        $0.image = UIImage(systemName: "p.circle")
        $0.tintColor = UIColor(rgb: 0xBFBFBF)
    }
    
    override func addView() {
        view.addSubviews(
            itemImageView,
            contentLabel,
            buyButton,
            currentPointLabel,
            currentPointImageView
        )
    }
    
    override func setLayout() {
        itemImageView.snp.makeConstraints {
            $0.height.equalTo((bound.height) / 2.16793893)
            $0.width.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        buyButton.snp.makeConstraints {
            $0.height.equalTo((bound.height)/17.75)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        currentPointLabel.snp.makeConstraints {
            $0.top.equalTo(buyButton.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
//            $0.leading.trailing.equalToSuperview().inset(16)
        }
        currentPointImageView.snp.makeConstraints {
            $0.height.width.equalTo(16)
            $0.top.equalTo(buyButton.snp.bottom).offset(6)
            $0.trailing.equalTo(currentPointLabel.snp.leading)
        }
    }
    
    override func bindView(reactor: ItemDetailReactor) {
        let request = reactor.initialState.itemDetailList
        
        self.itemTitle = request?.name ?? ""
        self.imageURL = request?.imageUrl ?? ""
        self.content =  request?.content ?? ""
        self.point = request?.price ?? 0
        self.id = request?.id ?? 0
        self.buyText = ("\(point)point로 구매하기")
        
        buyButton.rx.tap
            .map { ItemDetailReactor.Action.buyButtonTapped(
                itemTitle: self.itemTitle, point: self.point, id: self.id
            ) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindAction(reactor: ItemDetailReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in ItemDetailReactor.Action.fetchUserPoint }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: ItemDetailReactor) {
        reactor.state
            .map { $0.pointResponse }
            .subscribe(onNext: { pointResponse in
                self.currentPoint = pointResponse?.point ?? 0
                self.currentPointLabel.text =  String(self.currentPoint) + " 포인트"
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = self.itemTitle
        itemImageView.kf.setImage(with: URL(string: imageURL))
        contentLabel.text = content
        buyButton.setTitle(buyText, for: .normal)
    }
}
