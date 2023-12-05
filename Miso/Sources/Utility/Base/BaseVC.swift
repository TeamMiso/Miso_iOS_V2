import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import Then
import UIKit

class BaseVC<T>: UIViewController {
    let viewModel: T
    var disposeBag = DisposeBag()

    // MARK: - Properties

    let bound = UIScreen.main.bounds

    // MARK: - LifeCycle

    init(_ viewModel: T) {
        self.viewModel = viewModel
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
        bind(reactor: viewModel)
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

    func bind(reactor: T) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindView(reactor _: T) {}
    func bindAction(reactor _: T) {}
    func bindState(reactor _: T) {}

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}
