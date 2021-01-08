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
    @IBOutlet weak var searchBar: UISearchBar!
    
    let apiClient = APIClient()
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, usaData>
    private var dataSource: DataSource!
    
    var allUsaState = [usaData]()
    
    var filteredState = [usaData]() {
        didSet {
            loadData(usaData: filteredState)
        }
    }
    
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getDataFromJson()
        configureDataSource()
        loadData(usaData: allUsaState)
        searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
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
    
    private func getDataFromSearch(query: String)  {
        
        filteredState = allUsaState.filter {$0.state.lowercased() == query.lowercased()}
        
        loadData(usaData: filteredState)
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
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(layoutEnvironment.container.contentSize.height))
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

            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 3.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        })
    }
}

extension UsaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            getDataFromJson()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text!
        getDataFromSearch(query: searchQuery)
        searchBar.resignFirstResponder()
    }
    
}
