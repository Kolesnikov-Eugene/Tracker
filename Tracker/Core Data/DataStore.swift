//
//  DataStore.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 21.09.2023.
//

import UIKit
import CoreData

protocol DataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? { get }
    func deleteCategory(_ category: NSManagedObject) throws
    func addTracker(_ tarcker: TrackerProtocol, for category: String) throws
    func deleteTracker(_ tracker: NSManagedObject) throws
    func addTrackerRecord(_ record: TrackerRecordProtocol) throws
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int
    func trackerIsCompleted(_ trackerID: UUID, for currentDate: Date) throws -> Bool
    func deleteTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws
}

final class DataStore: DataStoreProtocol {
    
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
    private let context: NSManagedObjectContext
    
    init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

// MARK: - TrackerStore protocol
extension DataStore: TrackerStore {
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws {
        // check if category exists in CoreData.
        // if so, save tracker to DB at existing category
        let categoryID = try? fetchCategoryID(for: category, and: tracker.id)
        
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.categoryID = categoryID
        trackerCoreData.colorHex = tracker.color.hexString()
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.descriptionText = tracker.description
        trackerCoreData.schedule = tracker.schedule.map { String($0.rawValue) }.joined(separator: ",")
        
        let trackerCategory: TrackerCategoryCoreData?
        let categoryExixts = try! categoryExists(category)
        if !categoryExixts {
            trackerCategory = TrackerCategoryCoreData(context: context)
            trackerCategory!.id = categoryID
            trackerCategory!.category = category
        }
        
        try context.save()
    }
    
    func deleteTracker(_ tracker: NSManagedObject) throws {
    }
    
    func fetchTrackers(for categoryID: UUID) throws -> [TrackerProtocol] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.categoryID), categoryID as NSUUID)
        
        let trackersData = try context.fetch(request)
        var trackers = [TrackerProtocol]()
        trackersData.forEach { tracker in
            let id = tracker.id!
            let emoji = tracker.emoji!
            let color = tracker.colorHex?.colorFromHex()
            let description = tracker.descriptionText!
            let schedule: [Schedule] = tracker.schedule!.components(separatedBy: ",").map { Schedule(rawValue: Int($0)!)! }
            let newTracker = Tracker(id: id, emoji: emoji, color: color!, description: description, schedule: schedule)
            trackers.append(newTracker)
        }
        return trackers
    }
}

//MARK: - TrackerCategoryStore protocol
extension DataStore: TrackerCategoryStore {
    func deleteCategory(_ category: NSManagedObject) throws {
        //TODO later?
    }
    
    func fetchCategoryID(for categoryName: String, and trackerID: UUID) throws -> UUID? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCategoryCoreData.category), categoryName)
        
        let categoryID = try! context.fetch(request)
        
        if !categoryID.isEmpty {
            let id = categoryID[0].id ?? UUID()
            return id // the same categoryName has the same ID. There will no be two categoies with the same name and different ID
        } else {
            let id = UUID()
            return id
        }
    }
    
    func categoryExists(_ categoryName: String) throws -> Bool {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCategoryCoreData.category), categoryName)
        
        let category = try context.fetch(request)
        
        return !category.isEmpty
    }
    
    func fetchAllCategories() throws -> [TrackerCategoryProtocol] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        let categoriesData = try context.fetch(request)
        
        let categories: [TrackerCategoryProtocol] = try categoriesData.map { TrackerCategory(
            category: $0.category ?? "",
            trackerArray: try fetchTrackers(for: $0.id!)) }
        
        return categories
    }
}

//MARK: - TrackerRecordStore protocol
extension DataStore: TrackerRecordStore {
    func addTrackerRecord(_ record: TrackerRecordProtocol) throws {
        if try trackerIsCompleted(record.id, for: record.date) {
            try deleteTrackerRecord(record)
        } else {
            guard record.date <= Date() else { return }
            
            let trackerRecord = TrackerRecordCoreData(context: context)
            
            trackerRecord.trackerID = record.id
            trackerRecord.date = record.date.onlyDate
            
            try context.save()
        }
    }
    
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerID as NSUUID)
        
        let records = try context.fetch(request)
        
        return records.count
    }
    
    //this method is used to check if the tracker is completed to represent "done" status on the screen
    func trackerIsCompleted(_ trackerID: UUID, for currentDate: Date) throws -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let subPredicate1 = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerID as NSUUID)
        let subPredicate2 = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerRecordCoreData.date), currentDate.onlyDate)
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [subPredicate1, subPredicate2])
        request.predicate = andPredicate
        
        let result = try context.fetch(request)
        
        return !result.isEmpty
    }
    
    func deleteTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let subPredicate1 = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerRecord.id as NSUUID)
        let subPredicate2 = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerRecordCoreData.date), trackerRecord.date.onlyDate)
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [subPredicate1, subPredicate2])
        request.predicate = andPredicate
        
        let result = try context.fetch(request)
        
        context.delete(result[0]) // there always will be one record matching
        try context.save()
    }
}
