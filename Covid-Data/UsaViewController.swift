//
//  UsaViewController.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/30/20.
//

import UIKit
import Kingfisher

class UsaViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let apiClient = APIClient()
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, usaData>
    private var dataSource: DataSource!
    
    var allUsaState = [usaData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getDataFromJson()
        configureDataSource()
        loadData(usaData: allUsaState)
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
    }
    
    private func getDataFromJson() {
        allUsaState = usaData.getUSAData()
    }
    
    private func loadData(usaData: [usaData]) {
        var snapshot = dataSource.snapshot()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(allUsaState, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 5
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            
            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 2)
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 3)
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1000))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailingGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, usaData) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stateCell", for: indexPath) as? stateCell else {
                fatalError()
            }
            
            let url = URL(string: usaData.skyline_background_url)
            
            cell.imageView.kf.setImage(with: url)
            cell.stateName.text = usaData.state
            cell.backgroundColor = .tertiarySystemBackground
            
            return cell
        })
    }
    
}


extension UsaViewController: UICollectionViewDelegate {
    
}
