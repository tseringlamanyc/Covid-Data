//
//  ViewController.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/15/20.
//

import UIKit

class ViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth

        var sectionTitle: String {
            switch self {
            case .first:
                return "Asia"
            case .second:
                return "North America"
            case .third:
                return "South America"
            case .fourth:
                return "Europe"
            case .fifth:
                return "Africa"
            case .sixth:
                return "Australia"
            }
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, AllContientData>
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // item -> group -> section -> layout
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // figure out what section we are dealing with
            guard let _ = SectionKind(rawValue: sectionIndex) else {
                fatalError()
            }
            
            // item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 5
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            // group
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupSize, subitem: item, count: 3)
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1.0))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [innerGroup])
            
            // section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            // section header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }


    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as? countryCell else {
                fatalError()
            }
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView, let sectionKind = SectionKind(rawValue: indexPath.section) else {
                fatalError()
            }
            
            headerView.textLabel.text = sectionKind.sectionTitle
            headerView.textLabel.textAlignment = .left
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.first, .second, .third, .fourth, .fifth, .sixth])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
