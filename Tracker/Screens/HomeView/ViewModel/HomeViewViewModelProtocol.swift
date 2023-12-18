//
//  HomeViewViewModelProtocol.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 18.12.2023.
//

import Foundation

protocol HomeViewViewModelProtocol: AnyObject {
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
    func fetchCategory(for trackerID: UUID) -> String
}
