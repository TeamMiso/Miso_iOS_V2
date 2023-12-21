import UIKit
import Kingfisher

final class AIDetailVC: BaseVC<AIDetailReactor> {
    
    var id: Int = 0
    var contentTitle: String = ""
    var subTitle: String = ""
    var recycleMethod: String = ""
    var recycleTip: String = ""
    var recycleCaution: String = ""
    var image: UIImage?
    var recyclablesType: String = ""
    var recycleMarkUrl: String? = ""
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    private let recycleImageView = UIImageView()
    
    private let recycleQuestionLabel = UILabel().then {
        $0.text = "이 쓰레기는 어떤 쓰레기인가요?"
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 20, family: .extraBold)
    }
    
    private let subTitleRecycleTypeStackview = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    private let subTitleLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x3484DB)
        $0.font = .miso(size: 15, family: .regular)
    }
    
    private let recycleTypeStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private let recycleTypeLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
    }

    private let recycleTypeImageView = UIImageView()
    
    private let recycleStackview = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let recycleMethodLabel = UILabel().then {
        $0.text = "🤔 어떻게 분리배출하나요 ?"
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 20, family: .semiBold)
    }
    
    private let recycleMethodDetailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
    }
    
    private let recycleTipLabel = UILabel().then {
        $0.text = "😎 알아두면 좋은 점"
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 20, family: .semiBold)
    }
    
    private let recycleTipDetailLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
        $0.numberOfLines = 0
    }
    
    private let recycleCautionLabel = UILabel().then {
        $0.text = "⚠️ 유의할 점"
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 20, family: .semiBold)
    }
    
    private let recycleCautionDetailLabel = UILabel().then {
        $0.textColor = UIColor(rgb: 0x595959)
        $0.font = .miso(size: 15, family: .regular)
        $0.numberOfLines = 0
    }
    
    private let pointButton = NextStepButton().then {
        $0.setTitle("10 포인트 받기", for: .normal)
    }
     
    override func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func addView() {
        [
            recycleTypeLabel,
            recycleTypeImageView
        ].forEach{
            recycleTypeStackview.addArrangedSubview($0)
        }
        [
            subTitleLabel,
            recycleTypeStackview
        ].forEach{
            subTitleRecycleTypeStackview.addArrangedSubview($0)
        }
        [
            recycleQuestionLabel,
            subTitleRecycleTypeStackview,
            recycleMethodLabel,
            recycleMethodDetailLabel,
            recycleTipLabel,
            recycleTipDetailLabel,
            recycleCautionLabel,
            recycleCautionDetailLabel
        ].forEach{
            recycleStackview.addArrangedSubview($0)
        }
        scrollView.addSubviews(
            recycleImageView,
            recycleStackview,
            pointButton
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
        recycleImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo((bound.height) / 2.16793893)
            $0.width.equalToSuperview()
        }
        recycleTypeStackview.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.trailing.equalToSuperview().inset(240)
            $0.leading.equalToSuperview()
        }
        recycleTypeImageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }
        subTitleRecycleTypeStackview.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.equalToSuperview()
        }
        recycleStackview.snp.makeConstraints {
            $0.top.equalTo(recycleImageView.snp.bottom).offset(16)
            $0.bottom.equalTo(pointButton.snp.top).offset(-40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        pointButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
        }
    }

    override func bindView(reactor: AIDetailReactor) {
        let request = reactor.initialState.uploadRecyclablesList?.recyclablesList[0]
        
        self.id = request?.id ?? 0
        self.contentTitle = request?.title ?? ""
        self.subTitle = request?.subTitle ?? ""
        self.recycleMethod = request?.recycleMethod ?? ""
        self.recycleTip = request?.recycleTip ?? ""
        self.recycleCaution = request?.recycleCaution ?? ""
        self.image = reactor.initialState.originalImage
        self.recyclablesType = request?.recyclablesType ?? ""
        self.recycleMarkUrl = request?.recycleMark ?? ""
        
        pointButton.rx.tap
            .map { AIDetailReactor.Action.pointButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = contentTitle
        recycleImageView.image = self.image
        subTitleLabel.text = self.subTitle
        
        switch recyclablesType {
        case "CLOTHING":
            recycleTypeLabel.text = "분류 : 의류"
        case "PLASTIC":
            recycleTypeLabel.text = "분류 : 플라스틱"
        case "METAL":
            recycleTypeLabel.text = "분류 : 고철"
        case "PAPER_PACK":
            recycleTypeLabel.text = "분류 : 종이"
        case "GENERAL_TRASH":
            recycleTypeLabel.text = "분류 : 일반쓰레기"
        case "GLASS":
            recycleTypeLabel.text = "분류 : 유리"
        default:
            recycleTypeLabel.text = "분류 : "
        }
        
        recycleTypeImageView.kf.setImage(with: URL(string: recycleMarkUrl ?? ""))
        recycleMethodDetailLabel.text = self.recycleMethod
        recycleTipDetailLabel.text = self.recycleTip
        recycleCautionDetailLabel.text = self.recycleCaution

    }
}
