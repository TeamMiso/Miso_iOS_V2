import UIKit
import Kingfisher

final class DetailVC: BaseVC<DetailReactor> {
    
    var id: Int = 0
    var contentTitle: String = ""
    var subTitle: String = ""
    var content: String = ""
    var imageUrl: String = ""
    var recyclablesType: String = ""
    var recycleMarkUrl: String = ""
    
    private let recycleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
     
    override func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    override func addView() {
        view.addSubview(
            recycleImageView
        )
    }
    
    override func setLayout() {
        recycleImageView.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }

    override func bindView(reactor: DetailReactor) {
        let request = reactor.initialState.uploadRecyclablesList?.recyclablesList[0]
        
        self.id = request?.id ?? 0
        self.contentTitle = request?.title ?? ""
        self.subTitle = request?.subTitle ?? ""
        self.content = request?.content ?? ""
        self.imageUrl = request?.imageUrl ?? ""
        self.recyclablesType = request?.recyclablesType ?? ""
        self.recycleMarkUrl = request?.recycleMark ?? ""
        
        

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let imageUrl = URL(string: imageUrl) else { return }
        recycleImageView.kf.setImage(with: imageUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = contentTitle
        print(imageUrl)
        
    }
}
