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
//    func addCategory(_ category: TrackerCategoryProtocol) throws
    func deleteCategory(_ category: NSManagedObject) throws
    func addTracker(_ tarcker: TrackerProtocol, for category: String) throws
    func deleteTracker(_ tracker: NSManagedObject) throws
    func addTrackerRecord(_ record: TrackerRecordProtocol) throws
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]?
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int
    func checkIfTrackerIsCompleted(_ tracker: TrackerProtocol, for currentDate: Date) throws -> Bool
    func showCategory() throws
    func showTracker() throws
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
        
        let trackerCategory = TrackerCategoryCoreData(context: context)
        
        trackerCategory.id = categoryID
        trackerCategory.category = category
        trackerCategory.trackerID = tracker.id

        try context.save()
    }
    
    func deleteTracker(_ tracker: NSManagedObject) throws {
    }
    
    func fetchTrackers(for categoryID: UUID) throws -> [TrackerProtocol] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.categoryID), categoryID as NSUUID)
        
        let trackersData = try! context.fetch(request)
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
    
    func showTracker() {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")

        let trackers = try! context.fetch(request)


        print("-------------------------------------------------------------------")
        print("-------------------------------------------------------------------")
        print("HERE WE ARE PRINTING ALL THE TRACKERS EXISTING")
        print(trackers)
//        let id = trackers[0].id!
//        let emoji = trackers[0].emoji!
//        let color = trackers[0].colorHex?.colorFromHex()
//        let description = trackers[0].descriptionText!
//        let scheduleData = trackers[0].schedule
//        let newTracker = Tracker(id: id, emoji: emoji, color: color!, description: description, schedule: [.friday])
        print("-------------------------------------------------------------------")
        print("-------------------------------------------------------------------")
        print("-------------------------------------------------------------------")
        print("-------------------------------------------------------------------")
    }

    func showCategory() {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")

        let categories = try! context.fetch(request)

        print("-------------------------------------------------------------------")
        print("-------------------------------------------------------------------")
        print("HERE WE ARE PRINTING ALL THE CATEGORIES EXISTING")
        print(categories)
        print("-------------------------------------------------------------------")
        print("-------------------------------------------------------------------")
    }
}

//MARK: - TrackerCategoryStore protocol
extension DataStore: TrackerCategoryStore {
    func addCategory(_ categoryName: String, categoryID: UUID, with trackerID: UUID) throws {
        let trackerCategory = TrackerCategoryCoreData(context: context)
        
        trackerCategory.id = categoryID
        trackerCategory.category = categoryName
        trackerCategory.trackerID = trackerID
        
        try context.save()
    }
    
    func deleteCategory(_ category: NSManagedObject) throws {
    }
    
    func fetchCategoryID(for categoryName: String, and trackerID: UUID) throws -> UUID? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCategoryCoreData.category), categoryName)
        
        let categoryID = try! context.fetch(request)
        
        if !categoryID.isEmpty {
            let id = categoryID[0].id ?? UUID()
            
//            try? addCategory(categoryName, categoryID: id, with: trackerID)
            
            return id // the same categoryName has the same ID. There will no be two categoies with the same name and different ID
        } else {
            let id = UUID()
            
//            try? addCategory(categoryName, categoryID: id, with: trackerID)
            
            return id
        }
    }
    
    func fetchAllCategories() throws -> [TrackerCategoryProtocol]? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        let categoriesData = try! context.fetch(request)
        
        let categories: [TrackerCategoryProtocol] = categoriesData.map { TrackerCategory(
            category: $0.category!,
            trackerArray: try! fetchTrackers(for: $0.id!)) }
        
        return categories
    }
}

//MARK: - TrackerRecordStore protocol
extension DataStore: TrackerRecordStore {
    func addTrackerRecord(_ record: TrackerRecordProtocol) throws {
        let trackerRecord = TrackerRecordCoreData(context: context)
        
        trackerRecord.trackerID = record.id
        trackerRecord.date = record.date
        
        try context.save()
    }
    
    func fetchRecordsCounter(for trackerID: UUID) throws -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerID as NSUUID)
        
        let records = try! context.fetch(request)
        
        return records.count
    }
    
    func checkIfTrackerIsCompleted(_ tracker: TrackerProtocol, for currentDate: Date) throws -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let subPredicate1 = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), tracker.id as NSUUID)
        let subPredicate2 = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), currentDate as NSDate)
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [subPredicate1, subPredicate2])
        
        let result = try! context.fetch(request)
        
        return result.isEmpty
    }
}
