//
//  NullStore.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 21.09.2023.
//

import Foundation
import CoreData

final class NullStore {}

extension NullStore: TrackerStore {
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws {}
    func deleteTracker(_ tracker: NSManagedObject) throws {}
    var managedObjectContext: NSManagedObjectContext? { nil }
}

extension NullStore: TrackerCategoryStore {
    func addCategory(_ categoryName: String, categoryID: UUID, with trackerID: UUID) throws {}
    func deleteCategory(_ category: NSManagedObject) throws {}
}

extension NullStore: TrackerRecordStore {
    func deleteTrackerRecord(_ trackerRecord: TrackerRecordProtocol) throws {}
    func addTrackerRecord(_ record: TrackerRecordProtocol) throws {}
}
