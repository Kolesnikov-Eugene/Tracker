//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.09.2023.
//

import Foundation
import CoreData

protocol TrackerCategoryStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func deleteCategory(_ category: NSManagedObject) throws
}
