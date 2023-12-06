import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import Then
import UIKit

class BaseVC: UIViewController {
    var disposeBag = DisposeBag()

    // MARK: - Properties

    let bound = UIScreen.main.bounds

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupBackgroundIfNotSet()
        addView()
        setLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayoutSubviews()
    }

    // MARK: - Method

    private func setupBackgroundIfNotSet() {
        if view.backgroundColor == nil {
            view.backgroundColor = .white
        }
    }

    func setup() {}
    func addView() {}
    func setLayout() {}
    func setLayoutSubviews() {}

   
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}
