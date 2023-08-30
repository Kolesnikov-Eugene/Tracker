//
//  HomeViewConrtoller.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var addBarButtonItem: UIBarButtonItem?
    private var currentDate: Date?
    private var trackers: [Tracker]?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        return picker
    }()
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = true
        sc.searchBar.placeholder = "поиск"
        return sc
    }()
    private let emptyStateView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.width = 80
        view.frame.size.height = 80
        view.image = UIImage(named: "empty_home_view")
        
        return view
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        addSubviews()
        applyConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
        
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        view.addSubview(emptyStateLabel)
    }
    
    private func applyConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateView.heightAnchor.constraint(equalToConstant: 80),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor)
        ])
    }
    
    private func configureNavBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = true
            navigationItem.title = "Трекеры"
            
            addBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addTracker))
            navBar.topItem?.setLeftBarButton(addBarButtonItem, animated: false)
            
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = datePickerItem
            
            navigationItem.searchController = searchController
        }
    }
    
    @objc func addTracker() {
        let addTracker = AddTrackerViewController()
        let addTrackerNavigationCOntroller = UINavigationController(rootViewController: addTracker)
        
        present(addTrackerNavigationCOntroller, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    //TODO
}

extension HomeViewController: UICollectionViewDelegate {
    //TODO
}

