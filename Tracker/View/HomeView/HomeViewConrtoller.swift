//
//  HomeViewConrtoller.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

protocol NewHabitDelegate: AnyObject {
    func didCreateNewTracker(_ tracker: Tracker)
}

protocol HomeViewCellDelegate: AnyObject {
    func didTapDoneStatus(_ cell: HomeViewCollectionViewCell)
}

final class HomeViewController: UIViewController {
    
    private let reuseIdentifier = "TrackerViewCell"
    private var addBarButtonItem: UIBarButtonItem?
    private var currentDate = Date()
    private var categories: [TrackerCategory] = []
    private var trackers: [Tracker] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: TrackerRecord? = nil
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true

        return collectionView
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.calendar.firstWeekday = 2
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(datePickerDidChangeDate), for: .valueChanged)
        
        return picker
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        
        return searchController
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
        
        collectionView.register(HomeViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubviews()
        applyConstraints()
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
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
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
                image: UIImage(named: "add_tracker")?.withRenderingMode(.alwaysOriginal),
                style: .plain,
                target: self,
                action: #selector(addTracker)
            )
            navBar.topItem?.setLeftBarButton(addBarButtonItem, animated: false)
            
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = datePickerItem
            
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func filterTrackersByDate() {
        let curDate = DayOfWeekExtractor(date: currentDate)
        
        visibleCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackerArray.filter { tracker in
                let trackerDate = DayOfWeekExtractor(date: tracker.date!)
                // if date of creation is later than current picked date from date picker or tracker is not planned for this day
                // tracker is not displayed
                switch tracker.type {
                case .habit:
                    let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay) &&
                    trackerDate.date <= curDate.date
                    
                    return condition
                case .irregularIvent:
                    let condition = trackerDate.date <= curDate.date
                    
                    return condition
                }
                
            }
            if !filteredTrackers.isEmpty {
                return TrackerCategory(category: category.category,
                                       trackerArray: filteredTrackers)
            } else {
                return nil
            }
        }
        emptyStateView.isHidden = !visibleCategories.isEmpty
        emptyStateLabel.isHidden = !visibleCategories.isEmpty
        
    }
    
    private func applySearchQueryFilter(text: String) {
        var filteredCategories = [TrackerCategory]()
        for category in visibleCategories {
            let new = category.trackerArray.filter { $0.description.lowercased().contains(text.lowercased()) }
            if !new.isEmpty {
                let newCategory = TrackerCategory(category: category.category, trackerArray: new)
                filteredCategories.append(newCategory)
            }
        }
        visibleCategories = filteredCategories
        emptyStateView.isHidden = !visibleCategories.isEmpty
        emptyStateLabel.isHidden = !visibleCategories.isEmpty
    }
    
    @objc private func datePickerDidChangeDate(_ sender: UIDatePicker) {
        currentDate = sender.date
        filterTrackersByDate()
        collectionView.reloadData()
    }
    
    @objc func addTracker() {
        let addTracker = AddTrackerViewController(delegate: self)
        let addTrackerNavigationCOntroller = UINavigationController(rootViewController: addTracker)
        
        present(addTrackerNavigationCOntroller, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text else { return }
        applySearchQueryFilter(text: searchQuery)
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterTrackersByDate()
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchQuery = searchBar.text else { return }
        filterTrackersByDate()
        
        if !searchText.isEmpty {
            applySearchQueryFilter(text: searchQuery)
        }
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HomeViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        cell.delegate = self
        
        let currentTracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        cell.buttonChecked = currentTracker.trackerIsDoneAt.contains(currentDate.onlyDate)
        cell.configureCell(with: currentTracker)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as! SupplementaryView
        
        headerView.configureView(with: visibleCategories[indexPath.section])
        
        return headerView
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension HomeViewController: NewHabitDelegate {
    func didCreateNewTracker(_ tracker: Tracker) {
        var oldTrackers = [Tracker]()
        categories.forEach { category in
            if category.category == tracker.category {
                oldTrackers = category.trackerArray
                categories.removeAll { $0.category == tracker.category }
            }
        }
        oldTrackers.append(tracker)
        
        let newCategory = TrackerCategory(category: tracker.category, trackerArray: oldTrackers)
        categories.append(newCategory)
        
        filterTrackersByDate()
        collectionView.reloadData()
    }
}

extension HomeViewController: HomeViewCellDelegate {
    func didTapDoneStatus(_ cell: HomeViewCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            assertionFailure("Something went wrong")
            return
        }
        var oldTrackers = [Tracker]()
        var newTracker: Tracker? = nil
        var trackerIndex: Int = 0
        var categoryInd: Int = 0
        
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        
        if tracker.trackerIsDoneAt.isEmpty || !tracker.trackerIsDoneAt.contains(currentDate.onlyDate) {
            if let new = tracker.addCompletedDate(currentDate) {
                newTracker = new
            } else {
                newTracker = tracker
                
                print("Future date error!!!!")
                //TODO present alert of future date
            }
        } else if tracker.trackerIsDoneAt.contains(currentDate.onlyDate) {
            newTracker = tracker.removeCompletedDate(currentDate.onlyDate)
        }
        
        for (categoryIndex, category) in categories.enumerated() {
            if let index = category.trackerArray.firstIndex(where: { $0.id == tracker.id }) {
                oldTrackers = category.trackerArray
                trackerIndex = index
                categoryInd = categoryIndex
                categories.removeAll { $0.category == tracker.category }
            }
        }
        
        oldTrackers.remove(at: trackerIndex)
        oldTrackers.insert(newTracker!, at: trackerIndex)
        
        let newCategory = TrackerCategory(category: tracker.category, trackerArray: oldTrackers)
        categories.insert(newCategory, at: categoryInd)
        
        filterTrackersByDate()
        
        collectionView.reloadData()
    }
}


