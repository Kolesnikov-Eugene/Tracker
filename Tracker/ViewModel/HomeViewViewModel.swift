//
//  HomeViewViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 17.10.2023.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    var onState: (() -> Void)? { get set }
    var onSwitchToEmptyState: (() -> Void)? { get set }
    var onSwitchEmptyStateView: (() -> Void)? { get set }
    var onSwitchToEmptySearchResult: (() -> Void)? { get set }
    var visibleCategories: [TrackerCategoryProtocol] { get }
    var categories: [TrackerCategoryProtocol] { get }
    func datePickerDidChangeDate(_ date: Date)
    func searchFilterDidChangeState(_ searchQuery: String)
    func searchDidCancel()
    func searchTextDidChange(_ searchText: String)
    func getTrackerCompletionCounter(for tracker: TrackerProtocol) -> Int
    func trackerIsCompleted(_ trackerID: UUID) -> Bool
    func didTapDoneStatus(at indexPath: IndexPath)
    func createNewTracker(_ tracker: TrackerProtocol, category: String)
    func subscribe(_ section: Int)
}

final class HomeViewViewModel: HomeViewProtocol {
    
    private var currentDate = Date()
    private(set) var visibleCategories: [TrackerCategoryProtocol] = [] {
        didSet {
            onState?()
        }
    }
    private(set) var categories: [TrackerCategoryProtocol] = [] {
        didSet {
            onState?()
        }
    }
    private lazy var dataManager: DataManagerProtocol? = {
        configureDataManager()
    }()
    var onState: (() -> Void)?
    var onSwitchToEmptyState: (() -> Void)?
    var onSwitchEmptyStateView: (() -> Void)?
    var onSwitchToEmptySearchResult: (() -> Void)?
    
    init() {
        categories = fetchAllCategories()
        filterTrackersByDate()
    }
    
    private func configureDataManager() -> DataManagerProtocol? {
        let dataStore = DataStore()
        do {
            try dataManager = DataManager(dataStore, delegate: self)
            return dataManager
        } catch {
            print("error")
            return nil
        }
    }
    
    private func filterTrackersByDate() {
        onSwitchToEmptyState?()
        
        let curDate = DayOfWeekExtractor(date: currentDate)
        
        visibleCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackerArray.filter { tracker in
                let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay)
                return condition
            }
            if !filteredTrackers.isEmpty {
                return TrackerCategory(category: category.category,
                                       trackerArray: filteredTrackers)
            } else {
                return nil
            }
        }
        onSwitchEmptyStateView?()
    }
    
    private func applySearchQueryFilter(text: String) {
        onSwitchToEmptySearchResult?()
        
        var filteredCategories = [TrackerCategory]()
        for category in visibleCategories {
            let new = category.trackerArray.filter { $0.description.lowercased().contains(text.lowercased()) }
            if !new.isEmpty {
                let newCategory = TrackerCategory(category: category.category, trackerArray: new)
                filteredCategories.append(newCategory)
            }
        }
        visibleCategories = filteredCategories
        onSwitchEmptyStateView?()
    }
    
    func subscribe(_ section: Int) {
        let _ = dataManager?.numberOfSections
        let _ = dataManager?.numberOfSectionsOfCategories
        let _ = dataManager?.numberOfRowsInSection(section)
        let _ = dataManager?.numberOfRowsInSectionOfCategory(section)
    }
    
    func getTrackerCompletionCounter(for tracker: TrackerProtocol) -> Int {
        guard let counter = try? dataManager?.fetchRecordsCounter(for: tracker.id) else { return 0 }
        return counter
    }
    
    func trackerIsCompleted(_ trackerID: UUID) -> Bool {
        guard let completion = try? dataManager?.checkIfTrackerIsCompleted(trackerID, for: currentDate) else { return false }
        return completion
    }
    
    func datePickerDidChangeDate(_ date: Date) {
        currentDate = date
        filterTrackersByDate()
    }
    
    func searchFilterDidChangeState(_ searchQuery: String) {
        applySearchQueryFilter(text: searchQuery)
    }
    
    func searchDidCancel() {
        filterTrackersByDate()
    }
    
    func searchTextDidChange(_ searchText: String) {
        filterTrackersByDate()
        
        if !searchText.isEmpty {
            applySearchQueryFilter(text: searchText)
        }
    }
    
    func didTapDoneStatus(at indexPath: IndexPath) {
        let selectedTracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        let completedTracker = TrackerRecord(id: selectedTracker.id, date: currentDate)
        
        try? dataManager?.addTrackerRecord(completedTracker)
        
        filterTrackersByDate()
    }
    
    func createNewTracker(_ tracker: TrackerProtocol, category: String) {
        try? dataManager?.addTracker(tracker, for: category)
        
        categories = fetchAllCategories()
        filterTrackersByDate()
    }
}

//MARK: - DataManagerDelegate
extension HomeViewViewModel: DataManagerDelegate {
    func didUpdate() {
        categories = fetchAllCategories()
        filterTrackersByDate()
    }
    
    private func fetchAllCategories() -> [TrackerCategoryProtocol] {
        guard let categories = try? dataManager?.fetchAllCategories() else { return [] }
        return categories
    }
}
