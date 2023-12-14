import UIKit
import RxCocoa
import RxSwift
import Then
import ReactorKit
import SnapKit

class BaseVC<T: Reactor>: UIViewController, View {
    let reactor: T
    var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds
    let keychain = Keychain()
    
//    lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
    
    init(_ reactor: T) {
        self.reactor = reactor
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        setup()
        bind()
        addView()
        setLayout()
        bind(reactor: reactor)
    }
    
    func setup() {}
    
    func bind() {}
    
    func addView() {}
    
    func setLayout() {}
    
    func bind(reactor: T) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindView(reactor: T) {}
    func bindAction(reactor: T) {}
    func bindState(reactor: T) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

