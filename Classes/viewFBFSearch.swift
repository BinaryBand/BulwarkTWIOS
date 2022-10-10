//
//  viewFBFSearch.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 9/21/22.
//

import UIKit

class viewFBFSearch: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    var dataSource: DataSource!
   
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let listLayout = listLayout()
        /*
        lazy var gridLayout: UICollectionViewLayout = {
            let ignored = NSCollectionLayoutDimension.absolute(999)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: ignored,
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )

            let section = NSCollectionLayoutSection(group: group)

            return UICollectionViewCompositionalLayout(section: section)
        }()
*/
        
        collectionView.collectionViewLayout = listLayout

        let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder = FBFSearch.sampleData[indexPath.item]
            var contentConfiguration = FBFCellContentConfiguration()
                        contentConfiguration.text = reminder.title
                contentConfiguration.secondaryText = "3 years old"
                        cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(FBFSearch.sampleData.map { $0.title })
        dataSource.apply(snapshot)
        
        collectionView.dataSource = dataSource
        // Do any additional setup after loading the view.
    }
    

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = true
       // listConfiguration.headerMode = HeaderMode.firstItemInSection
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct FBFCellContentConfiguration: UIContentConfiguration {
    var text: String?
    var secondaryText: String?
    func makeContentView() -> UIView & UIContentView {
        FBFCellContent(configuration: self)
    }
    
    func updated(
        for state: UIConfigurationState
    ) -> FBFCellContentConfiguration {
        self
    }
}

// MARK: UIContentView
class TaskCell: UICollectionViewCell {

    @IBOutlet weak var exerciseTitle: UILabel!




}

class FBFCellContent: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        get { cellConfiguration }
        set { configureCell() }
    }
    private var cellConfiguration: FBFCellContentConfiguration
    private weak var label: UILabel!
 
    @IBOutlet var lblTimeBlock: UILabel!
    @IBOutlet var lblMiles: UILabel!
    @IBOutlet var btnAddToRoute: UIButton!
    
    @IBOutlet var lblRtTitle: UILabel!
    
    
    @IBOutlet var lblRouteFor: UILabel!
    
    
    
    init(configuration: FBFCellContentConfiguration) {
        self.cellConfiguration = configuration
        super.init(frame: .zero)
        addLabel()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        self.label = label
    }
    
    private func configureCell() {
        label.text = cellConfiguration.text
    }
}
