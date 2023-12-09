//import UIKit
//import Kingfisher
//
//final class ItemListVC: BaseVC{
//    var productList: [ProductEntity] = [
//        ProductEntity(id: 3_241_413, price: 150, amount: 3, name: "막대사탕", imageUrl: "Candy"),
//        ProductEntity(id: 3_241_413, price: 150, amount: 3, name: "막대사탕", imageUrl: "Candy"),
//        ProductEntity(id: 3_241_413, price: 150, amount: 3, name: "막대사탕", imageUrl: "Candy"),
//        ProductEntity(id: 3_241_413, price: 150, amount: 3, name: "막대사탕", imageUrl: "Candy"),
//        ProductEntity(id: 3_241_413, price: 150, amount: 3, name: "막대사탕", imageUrl: "Candy"),
//        ProductEntity(id: 3_241_413, price: 150, amount: 3, name: "막대사탕", imageUrl: "Candy"),
//    ]
//
//    lazy var pointCollectionView: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        view.backgroundColor = .white
//        return view
//    }()
//
//    private let flowLayout = UICollectionViewFlowLayout().then {
//        $0.itemSize = CGSize(width: 164, height: 235)
//        $0.scrollDirection = .vertical
//        $0.minimumLineSpacing = 8
//    }
//
//    override func setup() {
//        pointCollectionView.delegate = self
//        pointCollectionView.dataSource = self
//
//        pointCollectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
//        pointCollectionView.collectionViewLayout = flowLayout
////        flowLayout.minimumLineSpacing = 15
//    }
//
//    override func addView() {
//        view.addSubviews(
//            pointCollectionView
//        )
//    }
//
//    override func setLayout() {
//        pointCollectionView.snp.makeConstraints {
//            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
//            $0.leading.trailing.equalToSuperview().inset(16)
//            $0.bottom.equalToSuperview()
//        }
//    }
//}
//
//extension ItemListVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
//        return productList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier, for: indexPath)
//
//        if let cell = cell as? ItemListCell {
//            cell.productImageView.image = UIImage(named: productList[indexPath.item].imageUrl)
//            cell.productNameLabel.text = productList[indexPath.item].name
//            cell.productPriceLabel.text = String(productList[indexPath.item].price)
//        }
//
//        return cell
//    }
//
//    func     numberOfSections(in _: UICollectionView) -> Int {
//        return 1
//    }
//}
