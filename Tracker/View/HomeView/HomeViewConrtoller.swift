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
        
        
//        completedTrackers = TrackerRecord(date: currentDate,
//                                          idOfCompletedTrackers: <#T##[UUID]#>)
        
//        let curdate = DayOfWeekExtractor(date: Date())
//        let day = curdate.numberOfWeekDay
//        let myday = Schedule(rawValue: 3)
//        print("------------------------------------------------------")
//        print("------------------------------------------------------")
//        print(day)
//        print(curdate.dayOfWeekRussian)
//        print(curdate.dayOfWeek)
//        print(myday?.representCountOfWeekDays())
//        print(myday?.representFullDayName())
//        print(myday?.representShortDayName())
//        print(day == myday?.representCountOfWeekDays())
//        print("------------------------------------------------------")
//        print("------------------------------------------------------")
        
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
//            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
//            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
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
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addTracker))
            navBar.topItem?.setLeftBarButton(addBarButtonItem, animated: false)
            
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = datePickerItem
            
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func filterTrackers() -> [TrackerCategory] {
        //        let filteredCategories = [TrackerCategory]()
//        let date = DayOfWeekExtractor(date: currentDate)
        //        let filterdTrackers = [Tracker]()
        let date = DayOfWeekExtractor(date: currentDate)
        let filteredCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackerArray.filter { tracker in
                let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(date.numberOfWeekDay)
                return condition
            }
            if !filteredTrackers.isEmpty {
                return TrackerCategory(category: category.category,
                                       trackerArray: filteredTrackers)
            } else {
                return nil
            }
        }
        emptyStateView.isHidden = !filteredCategories.isEmpty
        emptyStateLabel.isHidden = !filteredCategories.isEmpty
        
        return filteredCategories
    }
    
    @objc private func datePickerDidChangeDate(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        let selectedDate = dateFormatter.string(from: sender.date)
        currentDate = sender.date
        
        collectionView.reloadData()
    }
    
    @objc func addTracker() {
        let addTracker = AddTrackerViewController(delegate: self)
        let addTrackerNavigationCOntroller = UINavigationController(rootViewController: addTracker)
        
        present(addTrackerNavigationCOntroller, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories = filterTrackers()
        
        return visibleCategories.count
        
//        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories = filterTrackers()
        return visibleCategories[section].trackerArray.count
//        return categories[section].trackerArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HomeViewCollectionViewCell else {
            return UICollectionViewCell()
        }
//        let currentD = currentDate
        cell.prepareForReuse()
        cell.delegate = self
        
        let currentTracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        cell.buttonChecked = currentTracker.trackerIsDoneAt.contains(currentDate.onlyDate)
        
        print("------------------------------------------")
        print("------------------------------------------")
        print(currentTracker.trackerIsDoneAt)
        print(currentDate.onlyDate)
        print(cell.buttonChecked)
        print(currentTracker.trackerIsDoneAt.contains(currentDate.onlyDate))
//        print(currentDate.onlyDate == currentTracker.trackerIsDoneAt)
        print("------------------------------------------")
        print("------------------------------------------")
        
        cell.configureCell(with: currentTracker)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as! SupplementaryView
        
        headerView.configureView(with: categories[indexPath.section]) // try if this works
        
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
//                oldTrackers = category.trackerArray
            }
        }
        oldTrackers.append(tracker)
        let newCategory = TrackerCategory(category: tracker.category, trackerArray: oldTrackers)
        categories.append(newCategory)
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
                
                print("ERROR FUTURE DATE-------------------------")
                print("ERROR FUTURE DATE-------------------------")
                print("ERROR FUTURE DATE-------------------------")
                print("ERROR FUTURE DATE-------------------------")
                print("ERROR FUTURE DATE-------------------------")
                print("ERROR FUTURE DATE-------------------------")
            }
        } else if tracker.trackerIsDoneAt.contains(currentDate.onlyDate) {
            print("Aaaaaaaaaaaaa_---------------------------------------")
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
        
        collectionView.reloadData()
//        cell.configureCell(with: newTracker)
    }
}

//private var trackers: [Tracker] = [
//    Tracker(
//        category: "Домашний уют",
//        emoji: emojiArray[0],
//        color: colorList[0],
//        description: "Do something when you want",
//        schedule: [.monday]
//    ),
//    Tracker(
//        category: "Домашний уют",
//        emoji: emojiArray[1],
//        color: colorList[0],
//        description: "Do something when you want",
//        schedule: [.monday]
//    ),
//    Tracker(
//        category: "Домашний уют",
//        emoji: emojiArray[2],
//        color: colorList[0],
//        description: "Do something when you want",
//        schedule: [.monday]
//    ),
//    Tracker(
//        category: "Домашний уют",
//        emoji: emojiArray[3],
//        color: colorList[0],
//        description: "Do something when you want",
//        schedule: [.monday]
//    )
//]
