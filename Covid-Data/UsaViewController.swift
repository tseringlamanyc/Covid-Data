//
//  UsaViewController.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/30/20.
//

import UIKit

class UsaViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, String>
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
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
        
    }
    
}


extension UsaViewController: UICollectionViewDelegate {
    
}
