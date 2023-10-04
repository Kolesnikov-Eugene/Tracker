//
//  DataManager.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.09.2023.
//

import Foundation
import CoreData

struct TrackerCategoryUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol DataManagerDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryUpdate)
}

protocol DataManagerProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData?
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws
    func deleteTracker(at indexPath: IndexPath) throws
    func addTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]?
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int
    func checkIfTrackerIsCompleted(_ tracker: TrackerProtocol, for currentDate: Date) throws -> Bool
    func printTrackers() throws
}

// MARK: - DataManager
final class DataManager: NSObject, NSFetchedResultsControllerDelegate {
    enum DataManagerError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: DataManagerDelegate?
    
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var dataStore: DataStoreProtocol
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(_ dataStore: DataStoreProtocol, delegate: DataManagerDelegate) throws {
        guard let context = dataStore.managedObjectContext else {
            throw DataManagerError.failedToInitializeContext
        }
        self.delegate = delegate
        self.context = context
        self.dataStore = dataStore
    }
}

extension DataManager: DataManagerProtocol {
    
    var numberOfSections: Int { //dont need it?
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int { //dont need it
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        fetchedResultsController.object(at: indexPath)
    }
    
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws {
        try? dataStore.addTracker(tracker, for: category)
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let tracker = fetchedResultsController.object(at: indexPath)
        try? dataStore.deleteTracker(tracker)
    }
    
    func addTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws {
        try? dataStore.addTrackerRecord(trackerRecord)
    }
    
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]? {
        try? dataStore.fetchAllCategories()
    }
    
    func printTrackers() throws { //DELETE LATER
        try? dataStore.showTracker()
        try? dataStore.showCategory()
    }
    
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int {
        try! dataStore.fetchRecordsCounter(for: trackerID)
    }
    
    func checkIfTrackerIsCompleted(_ tracker: TrackerProtocol, for currentDate: Date) throws -> Bool {
        try! dataStore.checkIfTrackerIsCompleted(tracker, for: currentDate)
    }
}
