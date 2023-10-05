//
//  TrackerStore.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.09.2023.
//

import Foundation
import CoreData

protocol TrackerStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func addTracker(_ tracker: TrackerProtocol, for category: String) throws
    func deleteTracker(_ tracker: NSManagedObject) throws
}
