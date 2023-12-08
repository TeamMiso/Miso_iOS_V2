import UIKit

final class SearchVC: BaseVC {
    private let betweenView = UIView().then {
        $0.backgroundColor = UIColor(rgb: 0x1C1C1E)
    }

    private let searchTextField = UITextField().then {
        $0.placeholder = ""
        $0.font = .miso(size: 16, family: .extraLight)
    }

    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = UIColor(rgb: 0x1C1C1E)
    }

    private let recentSearchesLabel = UILabel().then {
        $0.text = "최근 검색어"
        $0.textColor = UIColor(rgb: 0x000000)
        $0.font = .miso(size: 14, family: .extraLight)
    }

    override func setup() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0x1C1C1E)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func addView() {
        view.addSubviews(
            betweenView,
            searchTextField,
            searchButton,
            recentSearchesLabel
        )
    }

    override func setLayout() {
        searchButton.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalToSuperview().inset(16)
        }
        betweenView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(280)
            $0.bottom.equalTo(searchButton.snp.bottom)
            $0.trailing.equalTo(searchButton.snp.leading).inset(-20)
        }
        searchTextField.snp.makeConstraints {
            $0.width.equalTo(betweenView)
            $0.leading.equalTo(betweenView.snp.leading)
            $0.bottom.equalTo(betweenView.snp.top)
        }
        recentSearchesLabel.snp.makeConstraints {
            $0.top.equalTo(betweenView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(22)
        }
    }
}
