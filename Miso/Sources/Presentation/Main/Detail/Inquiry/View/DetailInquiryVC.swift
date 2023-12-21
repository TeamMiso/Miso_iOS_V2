import UIKit
import Kingfisher

final class DetailInquiryVC: BaseVC<DetailInquiryReactor> {
    
    var inquiryId: Int = 0
    var inquiryDate: String = ""
    var inquiryTitle: String = ""
    var inquiryContent: String = ""
    var inquiryImageUrl: String = ""
    var inquiryStatus: String = ""
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    var dateAndStatusStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
    }
    
    private let statusLabel = UILabel().then {
        $0.font = .miso(size: 15, family: .regular)
    }

    private let inquiryImageView = UIImageView()
    
    private let inquiryContentTitleLabel = UILabel().then {
        $0.text = "문의 내용"
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 20, family: .semiBold)
        $0.numberOfLines = 0
    }
    
    private let inquiryContentLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
        $0.numberOfLines = 0
    }
    
    override func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func addView() {
        [
            dateLabel,
            statusLabel
        ].forEach{
            dateAndStatusStackview.addArrangedSubview($0)
        }
        scrollView.addSubviews(
            dateAndStatusStackview,
            inquiryImageView,
            inquiryContentTitleLabel,
            inquiryContentLabel
        )
        view.addSubview(
            scrollView
        )
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        dateAndStatusStackview.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        inquiryImageView.snp.makeConstraints {
            $0.height.equalTo((bound.height) / 2.16793893)
            $0.width.equalToSuperview()
            $0.top.equalTo(dateAndStatusStackview.snp.bottom).offset(4)
            
        }
        inquiryContentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(inquiryImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        inquiryContentLabel.snp.makeConstraints {
            $0.top.equalTo(inquiryContentTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
    }
    
    override func bindState(reactor: DetailInquiryReactor) {
        reactor.state
            .map { $0.detailInquiryResponse }
            .subscribe(onNext: { response in
                guard let response = response else { return }
                
                self.inquiryId = response.id
                self.inquiryDate = response.inquiryDate
                self.inquiryTitle = response.title
                self.inquiryContent = response.content
                self.inquiryImageUrl = response.imageUrl
                self.inquiryStatus = response.inquiryStatus
                
                let dateStr = self.inquiryDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'H:mm:ss.SSS" // 23.12.20
                let convertDate = dateFormatter.date(from: dateStr) // Date 타입으로 변환
                
                let stringFormatter = DateFormatter()
                stringFormatter.dateFormat = "yyyy.MM.dd"
                let convertStr = stringFormatter.string(from: convertDate!)
                
                if response.inquiryStatus == "WAIT" {
                    self.statusLabel.text = "검토중"
                    self.statusLabel.textColor = UIColor(rgb: 0xBFBFBF)
                } else {
                    self.statusLabel.text = "답변 완료"
                    self.statusLabel.textColor = UIColor(rgb: 0x25D07D)
                }
                
                self.navigationItem.title = self.inquiryTitle
                self.dateLabel.text = convertStr
                self.inquiryImageView.kf.setImage(with: URL(string: self.inquiryImageUrl))
                self.inquiryContentLabel.text = self.inquiryContent

            })
            .disposed(by: disposeBag)
    }
}
