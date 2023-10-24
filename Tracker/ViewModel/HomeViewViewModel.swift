//
//  HomeViewViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 17.10.2023.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    var currentDate: Date { get set }
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
    func editTracker(_ tracker: TrackerProtocol, category: String)
    func deleteTracker(_ tracker: TrackerProtocol)
    func pinTracker(_ tracker: TrackerProtocol)
    func trackerIsPinned(_ trackerID: UUID) -> Bool
    func subscribe()
}

protocol FilterPickerDelegate: AnyObject {
    var filter: String { get set }
    func didRecieveFilter(_ filter: Filter)
}

final class HomeViewViewModel: HomeViewProtocol {
    
    private let analyticsService = AnalyticsService()
    private var pinnedTrackersForCurrentDay: [TrackerProtocol] = []
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
    private lazy var trackersManager: TrackersManagerProtocol? = {
        configureTrackersManager()
    }()
    var currentDate = Date()
    var filter = ""
    var onState: (() -> Void)?
    var onSwitchToEmptyState: (() -> Void)?
    var onSwitchEmptyStateView: (() -> Void)?
    var onSwitchToEmptySearchResult: (() -> Void)?
    
    init() {
        categories = fetchAllCategories()
        filterTrackersByDate()
    }
    
    private func configureTrackersManager() -> TrackersManagerProtocol? {
        let dataStore = DataStore()
        do {
            try trackersManager = TrackersManager(dataStore, delegate: self)
            return trackersManager
        } catch {
            print("error")
            return nil
        }
    }
    
    private func filterTrackersByDate() {
        onSwitchToEmptyState?()
        
        let curDate = DayOfWeekExtractor(date: currentDate)
        
        let pinnedIDs = fetchPinnedTrackersIDs()
        
        visibleCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackerArray.filter { tracker in
                let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay) && !pinnedIDs.contains(tracker.id)
                return condition
            }
            if !filteredTrackers.isEmpty {
                return TrackerCategory(category: category.category,
                                       trackerArray: filteredTrackers)
            } else {
                return nil
            }
        }
        
        let allPinnedTrackers = fetchPinnedTrackers()
        pinnedTrackersForCurrentDay = allPinnedTrackers
            .filter { $0.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay) }
        
        if !pinnedTrackersForCurrentDay.isEmpty {
            let pinnedCategory = TrackerCategory(category: "Закрепленные", trackerArray: pinnedTrackersForCurrentDay)
            self.visibleCategories.insert(pinnedCategory, at: 0)
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
    
    func subscribe() {
        
        let _ = trackersManager?.numberOfSections
//        let _ = trackersManager?.numberOfSectionsOfCategories
//        let _ = dataManager?.numberOfRowsInSection(section)
//        let _ = dataManager?.numberOfRowsInSectionOfCategory(section)
    }
    
    func getTrackerCompletionCounter(for tracker: TrackerProtocol) -> Int {
        guard let counter = try? trackersManager?.fetchRecordsCounter(for: tracker.id) else { return 0 }
        return counter
    }
    
    func trackerIsCompleted(_ trackerID: UUID) -> Bool {
        guard let completion = try? trackersManager?.checkIfTrackerIsCompleted(trackerID, for: currentDate) else { return false }
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
        
        try? trackersManager?.addTrackerRecord(completedTracker)
        
        filterTrackersByDate()
    }
    
    func createNewTracker(_ tracker: TrackerProtocol, category: String) {
        try? trackersManager?.addTracker(tracker, for: category)
        
//        categories = fetchAllCategories()
//        filterTrackersByDate()
    }
    
    //redone
    func editTracker(_ tracker: TrackerProtocol, category: String) {
        try? trackersManager?.editTracker(tracker, for: category)
        
        //        categories = fetchAllCategories()
        //        filterTrackersByDate()
    }
    
    func deleteTracker(_ tracker: TrackerProtocol) {
        try? trackersManager?.deleteTracker(tracker)
        
        //        categories = fetchAllCategories()
        //        filterTrackersByDate()
    }
    
    func pinTracker(_ tracker: TrackerProtocol) {
        try? trackersManager?.pinTracker(tracker)

        categories = fetchAllCategories()
        filterTrackersByDate()
    }
    
    private func filterCompletedTrackers() {
        onSwitchToEmptySearchResult?()
        
        let completedTrackersIDs = fetchCompletedTrackersIDs()
        filterTrackers(completedTrackersIDs, option: .completed)
        
        onSwitchToEmptySearchResult?()
    }
    
    private func filterUncompletedTrackers() {
        onSwitchToEmptySearchResult?()
        
        let completedTrackersIDs = fetchCompletedTrackersIDs()
        filterTrackers(completedTrackersIDs, option: .uncompleted)
        
        onSwitchToEmptySearchResult?()
    }
    
    private func filterTrackers(_ trackerIDs: [UUID]? = nil, option: Filter) {
        let curDate = DayOfWeekExtractor(date: currentDate)
        
        visibleCategories = categories.compactMap { category -> TrackerCategory? in
            var filteredTrackers: [TrackerProtocol] = []
            switch option {
            case .all:
                filteredTrackers = category.trackerArray.filter { tracker in
                    let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay)
                    return condition
                }
            case .uncompleted:
                guard let trackerIDs = trackerIDs else { return nil }
                filteredTrackers = category.trackerArray.filter { tracker in
                    let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay) && !trackerIDs.contains(tracker.id)
                    return condition
                }
            case .completed:
                guard let trackerIDs = trackerIDs else { return nil }
                filteredTrackers = category.trackerArray.filter { tracker in
                    let condition = tracker.schedule.map { $0.representCountOfWeekDays() }.contains(curDate.numberOfWeekDay) && trackerIDs.contains(tracker.id)
                    return condition
                }
            default:
                break
            }
            
            if !filteredTrackers.isEmpty {
                return TrackerCategory(category: category.category,
                                       trackerArray: filteredTrackers)
            } else {
                return nil
            }
        }
    }
    
    private func fetchCompletedTrackersIDs() -> [UUID] {
        guard let completedTrackersIDs: [UUID] = try? trackersManager?.fetchCompletedTrackersIDs(for: currentDate) else {
            visibleCategories = []
            onSwitchToEmptySearchResult?()
            return []
        }
        return completedTrackersIDs
    }
    
    private func fetchPinnedTrackers() -> [TrackerProtocol] {
        guard let trackers = try? trackersManager?.fetchPinnedTrackers() else { return [] }
        return trackers
    }
    
    private func fetchPinnedTrackersIDs() -> [UUID] {
        guard let ids = try? trackersManager?.fetchPinnedTrackersIDs() else { return [] }
        return ids
    }
    
    func trackerIsPinned(_ trackerID: UUID) -> Bool {
        let ids = fetchPinnedTrackersIDs()
        
        return ids.contains(trackerID)
    }
}

//MARK: - DataManagerDelegate
extension HomeViewViewModel: TrackersManagerDelegate {
    func didUpdate() {
        categories = fetchAllCategories()
        filterTrackersByDate()
    }
    
    private func fetchAllCategories() -> [TrackerCategoryProtocol] {
        guard let categories = try? trackersManager?.fetchAllCategories() else { return [] }
        return categories
    }
}

//MARK: - FilterPickerDelegate
extension HomeViewViewModel: FilterPickerDelegate {
    func didRecieveFilter(_ filter: Filter) {
        self.filter = filter.representFilterText()
        
        switch filter {
        case .all:
            filterTrackersByDate()
        case .today:
            currentDate = Date()
            filterTrackersByDate()
        case .completed:
            filterCompletedTrackers()
        case .uncompleted:
            filterUncompletedTrackers()
        }
    }
}
