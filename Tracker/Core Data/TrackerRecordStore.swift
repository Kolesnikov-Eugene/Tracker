//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.09.2023.
//

import Foundation
import CoreData

protocol TrackerRecordStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func addTrackerRecord(_ record: TrackerRecordProtocol) throws
}
