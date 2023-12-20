import UIKit
import SnapKit
import Kingfisher

final class ItemDetailVC: BaseVC<ItemDetailReactor> {
    
    var itemTitle: String = ""
    var imageURL: String = ""
    var content: String = ""
    var point: Int = 0
    var id: Int = 0
    var buyText: String = ""
    
    private let itemImageView = UIImageView()
    
    private let contentLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
    }
    
    private let buyButton = NextStepButton()
    
    override func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func addView() {
        view.addSubviews(
            itemImageView,
            contentLabel,
            buyButton
        )
    }
    
    override func setLayout() {
        itemImageView.snp.makeConstraints {
            $0.height.equalTo((bound.height)/3.23)
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
                id: self.id
            ) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = itemTitle
        itemImageView.kf.setImage(with: URL(string: imageURL))
        contentLabel.text = content
        buyButton.setTitle(buyText, for: .normal)
    }
}
