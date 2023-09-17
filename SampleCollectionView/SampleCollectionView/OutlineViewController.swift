//
//  OutlineViewController.swift
//  SampleCollectionView
//
//  Created by Saya Matsui on 2023/09/17.
//

import UIKit

final class OutlineViewController: UIViewController, UICollectionViewDelegate {
    enum Section {
        case main
    }

    struct OutlineItem: Hashable {
        let title: String
        let subItems: [OutlineItem]
        //        let outlineViewController: UIViewController.Type?
    }

    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
    var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    //    var outlineCollectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Modern Collection Views"
        configureCollectionView()
        configureDataSource()
        applySnapshot()
    }

    func configureCollectionView() {
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }

    func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, item in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration

            let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: options)]
//            cell.backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
        }

        dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: OutlineItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        //        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
        //            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        //        })
    }
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        let items = makeItems()
        snapshot.append(items)
        dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }

    func makeItems() -> [OutlineItem] {
        let item = OutlineItem(title: "sayaplayer", subItems: [])
        return [item]
    }

}
