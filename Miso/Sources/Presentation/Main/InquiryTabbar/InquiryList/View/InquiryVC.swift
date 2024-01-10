import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources


final class InquiryVC: BaseVC<InquiryReactor> {
    
    private let misoLogoImage = UIImageView().then {
        $0.image = UIImage(named: "MisoLogo-Green")
    }
    
    private let misoLabel = UILabel().then {
        $0.text = "Miso"
        $0.textColor = UIColor(rgb: 0x25D07D)
        $0.font = .miso(size: 32, family: .semiBold)
    }
    
    private let writeInquiryButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("  문의하기", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0xBFBFBF), for: .normal)
        $0.tintColor = UIColor(rgb: 0xBFBFBF)
        $0.titleLabel?.font = .miso(size: 16, family: .medium)
    }
    
    let inquiryListFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
    }
    
    lazy var inquiryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: inquiryListFlowLayout).then {
        $0.register(InquiryListCell.self, forCellWithReuseIdentifier: InquiryListCell.identifier)
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
            writeInquiryButton,
            inquiryListCollectionView
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
        writeInquiryButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(misoLogoImage.snp.top).offset(4)
            $0.trailing.equalToSuperview().inset(16)
        }
        inquiryListCollectionView.snp.makeConstraints {
            $0.top.equalTo(misoLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bindView(reactor: InquiryReactor) {
        
        writeInquiryButton.rx.tap
            .map { _ in Reactor.Action.writeInquiryButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inquiryListCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let row = indexPath.row
                
                guard let currentState = self.reactor?.currentState else { return }
                let id = "\(currentState.myInquiryResponse[row].id)"
                self.reactor?.action.onNext(.inquiryDetaillButtonTapped(inquiryId: id))
            })
            .disposed(by: disposeBag)
    }
    
    override func bindAction(reactor: InquiryReactor) {
        self.rx.viewWillAppear
            .map { _ in InquiryReactor.Action.fetchInquiryList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: InquiryReactor) {
        reactor.state
            .map{ $0.myInquiryResponse}
            .bind(to: inquiryListCollectionView.rx.items(
                cellIdentifier: "InquiryListCell", cellType: InquiryListCell.self)
            ) {
                index, response, cell in
                
                let dateStr = response.inquiryDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'H:mm:ss.SSS" // 23.12.20
                let convertDate = dateFormatter.date(from: dateStr) // Date 타입으로 변환
                
                let stringFormatter = DateFormatter()
                stringFormatter.dateFormat = "yy.MM.dd"
                let convertStr = stringFormatter.string(from: convertDate!)
                
                if response.inquiryStatus == "WAIT" {
                    cell.statusLabel.text = "검토중"
                    cell.statusLabel.textColor = UIColor(rgb: 0xBFBFBF)
                } else {
                    cell.statusLabel.text = "답변 완료"
                    cell.statusLabel.textColor = UIColor(rgb: 0x25D07D)
                }
                
                cell.requestDateLabel.text = convertStr
                cell.itemTitleLabel.text = response.title
                cell.itemImageView.kf.setImage(with: URL(string: response.imageUrl))
                
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

