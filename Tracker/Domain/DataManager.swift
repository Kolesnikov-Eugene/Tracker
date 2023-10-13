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
    func didUpdate()
}

protocol CategoriesManagerProtocol {
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]
    func addCategory(_ category: String) throws
}

protocol DataManagerProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws
    func deleteTracker(at indexPath: IndexPath) throws
    func addTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int
    func checkIfTrackerIsCompleted(_ trackerID: UUID, for currentDate: Date) throws -> Bool
}

// MARK: - DataManager
final class DataManager: NSObject {
    enum DataManagerError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: DataManagerDelegate?
    
    private var currentSection: Int?
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var dataStore: DataStoreProtocol
    
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
    
    private lazy var categoriesFetchedResultsController:  NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
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
    
    init(_ dataStore: DataStoreProtocol) throws {
        guard let context = dataStore.managedObjectContext else {
            throw DataManagerError.failedToInitializeContext
        }
        self.context = context
        self.dataStore = dataStore
    }
}

extension DataManager: DataManagerProtocol {
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    var numberOfSectionsOfCategories: Int {
        categoriesFetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard section <= numberOfSections else { return 0 }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfRowsInSectionOfCategory(_ section: Int) -> Int {
        guard section <= numberOfSectionsOfCategories else { return 0 }
        return categoriesFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws {
        try? dataStore.addTracker(tracker, for: category)
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let tracker = fetchedResultsController.object(at: indexPath)
        try? dataStore.deleteTracker(tracker)
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
}

extension DataManager: CategoriesManagerProtocol {
    func addCategory(_ category: String) throws {
        try dataStore.addCategory(category)
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any, at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete, .insert:
            delegate?.didUpdate()
        default:
            break
        }
    }
}
