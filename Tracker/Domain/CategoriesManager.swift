//
//  CategoriesManager.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 22.10.2023.
//

import Foundation
import CoreData

protocol CategoriesManagerDelegate: AnyObject {
    func didUpdate()
}

protocol CategoriesManagerProtocol {
    var numberOfSectionsOfCategories: Int { get }
//    func numberOfRowsInSectionOfCategory(_ section: Int) -> Int
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]
    func addCategory(_ category: String) throws
    func renameCategory(_ category: String, for oldCategory: String) throws
    func deleteCategory(_ category: String) throws
}

// MARK: - CategoriesManager
final class CategoriesManager: NSObject {
    enum DataManagerError: Error {
        case failedToInitializeContext
    }
    
    private let context: NSManagedObjectContext
    private var dataStore: DataStoreProtocol
    
    private lazy var categoriesFetchedResultsController:  NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "id",
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    weak var delegate: CategoriesManagerDelegate?
    
    init(_ dataStore: DataStoreProtocol, delegate: CategoriesManagerDelegate) throws {
        guard let context = dataStore.managedObjectContext else {
            throw DataManagerError.failedToInitializeContext
        }
        self.context = context
        self.dataStore = dataStore
        self.delegate = delegate
    }
}

//MARK: - CategoriesManagerProtocol
extension CategoriesManager: CategoriesManagerProtocol {
    func fetchAllCategories() throws -> [TrackerCategoryProtocol] {
        try dataStore.fetchAllCategories()
    }
    
    var numberOfSectionsOfCategories: Int {
        categoriesFetchedResultsController.sections?.count ?? 0
    }
//
//    func numberOfRowsInSectionOfCategory(_ section: Int) -> Int {
//        guard section <= numberOfSectionsOfCategories else { return 0 }
//        return categoriesFetchedResultsController.sections?[section].numberOfObjects ?? 0
//    }
    
    func addCategory(_ category: String) throws {
        try dataStore.addCategory(category)
    }
    
    func renameCategory(_ category: String, for oldCategory: String) throws {
        try dataStore.renameCategory(category, for: oldCategory)
    }
    
    func deleteCategory(_ category: String) throws {
        try dataStore.deleteCategory(category)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension CategoriesManager: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        delegate?.didUpdate()
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
    
//    func controller(
//        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
//        didChange anObject: Any, at indexPath: IndexPath?,
//        for type: NSFetchedResultsChangeType,
//        newIndexPath: IndexPath?
//    ) {
//        switch type {
//        case .delete, .insert, .update:
//            delegate?.didUpdate()
//        default:
//            break
//        }
//    }
}
