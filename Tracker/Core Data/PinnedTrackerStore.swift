//
//  PinnedTrackerStore.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import Foundation
import CoreData

protocol PinnedTrackerStore {
    var managedObjectContext: NSManagedObjectContext? { get }
//    func fetchPinnedTrackers() throws -> [TrackerProtocol]
}
