import UIKit
import ReactorKit
import Then
import RxSwift
import SnapKit

class BaseVC<T: Reactor>: UIViewController {
    let bound = UIScreen.main.bounds
    var disposeBag: DisposeBag = .init()
    
    private let indicatorBackgroundView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        addView()
        setLayout()
        configureVC()
        configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayoutSubviews()
    }

    init(reactor: T?) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func setup() {}
    func addView() {}
    func setLayout() {}
    func setLayoutSubviews() {}
    func configureVC() {}
    func configureNavigation() {}

    func bindView(reactor: T) {}
    func bindAction(reactor: T) {}
    func bindState(reactor: T) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension BaseVC: View {
    func bind(reactor: T) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}
