//
//  TrackersManager.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 22.10.2023.
//

import Foundation
import CoreData

protocol TrackersManagerDelegate: AnyObject {
    func didUpdate()
}

protocol TrackersRecordManagerProtocol {
    func fetchCompletedTrackersCounter() throws -> [TrackerRecord]?
}

protocol TrackersManagerProtocol {
    var numberOfSections: Int { get }
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws
    func deleteTracker(_ tracker: TrackerProtocol) throws
    func addTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int
    func checkIfTrackerIsCompleted(_ trackerID: UUID, for currentDate: Date) throws -> Bool
    func fetchCompletedTrackersIDs(for date: Date)  throws -> [UUID]
    func editTracker(_ tracker: TrackerProtocol, for category: String) throws
    func pinTracker(_ tracker: TrackerProtocol) throws
    func fetchPinnedTrackersIDs() throws -> [UUID]
    func fetchPinnedTrackers() throws -> [TrackerProtocol]
}

// MARK: - TrackersManager
final class TrackersManager: NSObject {
    enum DataManagerError: Error {
        case failedToInitializeContext
    }
    
    private let context: NSManagedObjectContext
    private let dataStore: DataStoreProtocol
    private lazy var fetchedResultsController:  NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryID", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "categoryID",
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    weak var delegate: TrackersManagerDelegate?
    
    init(_ dataStore: DataStoreProtocol, delegate: TrackersManagerDelegate) throws {
        guard let context = dataStore.managedObjectContext else {
            throw DataManagerError.failedToInitializeContext
        }
        self.delegate = delegate
        self.context = context
        self.dataStore = dataStore
    }
    
    init(_ dataStore: DataStoreProtocol) throws {
        guard let context = dataStore.managedObjectContext else {
            throw DataManagerError.failedToInitializeContext
        }
        self.context = context
        self.dataStore = dataStore
    }
}

//MARK: - TrackersManagerProtocol
extension TrackersManager: TrackersManagerProtocol {
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws {
        try? dataStore.addTracker(tracker, for: category)
    }
    
    func deleteTracker(_ tracker: TrackerProtocol) throws {
        try? dataStore.deleteTracker(tracker)
    }
    
    func editTracker(_ tracker: TrackerProtocol, for category: String) throws {
        try? dataStore.editTracker(tracker, for: category)
    }
    
    func fetchAllCategories() throws -> [TrackerCategoryProtocol] {
        try dataStore.fetchAllCategories()
    }
    
    func addTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws {
        try? dataStore.addTrackerRecord(trackerRecord)
    }
    
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int {
        try dataStore.fetchRecordsCounter(for: trackerID)
    }
    
    func checkIfTrackerIsCompleted(_ trackerID: UUID, for currentDate: Date) throws -> Bool {
        try dataStore.trackerIsCompleted(trackerID, for: currentDate)
    }
    
    func fetchCompletedTrackersIDs(for date: Date)  throws -> [UUID] {
        try dataStore.fetchCompletedTrackersIDs(for: date)
    }
    
    func pinTracker(_ tracker: TrackerProtocol) throws {
        try dataStore.pinTracker(tracker)
    }
    
    func fetchPinnedTrackersIDs() throws -> [UUID] {
        try dataStore.fetchPinnedTrackersIDs()
    }
    
    func fetchPinnedTrackers() throws -> [TrackerProtocol] {
        try dataStore.fetchPinnedTrackers()
    }
}
//MARK: - TrackersRecordManagerProtocol
extension TrackersManager: TrackersRecordManagerProtocol {
    func fetchCompletedTrackersCounter() throws -> [TrackerRecord]? {
        try dataStore.fetcAllCompletedTrackersCounter()
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackersManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
