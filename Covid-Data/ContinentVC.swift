//
//  ViewController.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/15/20.
//

import UIKit
import Kingfisher
import Combine

class ContinentVC: UIViewController {
    
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
                return "Australia/Oceania"
            }
        }
        
        var itemCount: Int {
            switch self {  // SectionKind
            case .first:
                return 2
            default:
                return 1
            }
        }
        
        var innerGroupHeight: NSCollectionLayoutDimension {
            switch self {
            case .first:
                return .fractionalWidth(1.0)
            default:
                return .fractionalWidth(0.45)
            }
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, String>
    private var dataSource: DataSource!
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, String>
    
    let apiClinet = APIClient()
    
    var searchQuery = ""
    
    var newCountryData = [AllCountries]()
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredContinent = [AllContientData]() {
        didSet {
            updateSnapshot(continents: filteredContinent)
        }
    }
    
    var allContinent = [AllContientData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        loadData()
        newData()
        searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    private func loadData() {
        apiClinet.fetchAllContinents()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Done")
                }
            } receiveValue: { [weak self] allData in
                self?.updateSnapshot(continents: allData)
                self?.allContinent = allData
            }
            .store(in: &cancellables)
    }
    
    private func newData() {
        apiClinet.dataForFlag()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                  print("Done")
                }
            } receiveValue: { [weak self] allData in
                self?.newCountryData = allData
            }
            .store(in: &cancellables)
    }
    
    private func getContinentFromSearch(query: String) {
        filteredContinent = allContinent.filter {$0.continent.lowercased().contains(query.lowercased())}
    }
    
    private func updateSnapshot(continents: [AllContientData]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.first, .second, .third, .fourth, .fifth, .sixth])
        
        for (index, covidData) in continents.enumerated() {
            snapshot.appendItems(covidData.countries, toSection: SectionKind.allCases[index])
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { return nil }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 10
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(1.0))
            let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: sectionKind.itemCount)
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: sectionKind.innerGroupHeight)
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [innerGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [self] (collectionView, indexPath, country) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "covidCell", for: indexPath) as? CountryCell else {
                fatalError()
            }
            
            var countryURL = ""
            
            for data in newCountryData {
                if country == data.country {
                    countryURL += data.countryInfo.flag
                }
            }
            
            let url = URL(string: countryURL)
            
            cell.imageView.kf.setImage(with: url)
            cell.countryName.text = country
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView, let sectionKind = SectionKind(rawValue: indexPath.section) else {
                fatalError()
            }
            
            headerView.textLabel.text = sectionKind.sectionTitle.uppercased()
            headerView.textLabel.textAlignment = .left
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
}

extension ContinentVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let country = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        print(indexPath)
        print("The name of the country is \(country)")
        
        guard let countryVC = storyboard?.instantiateViewController(identifier: "CountryVC", creator: { (coder)  in
            return CountryVC(coder: coder, country: country)
        }) else {
            fatalError("couldnt segue to countryVC")
        }
        
        navigationController?.pushViewController(countryVC, animated: true)
        
    }
}

extension ContinentVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredContinent = allContinent
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text!
        getContinentFromSearch(query: searchQuery)
        searchBar.resignFirstResponder()
    }
}
