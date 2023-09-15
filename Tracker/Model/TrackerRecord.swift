//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import Foundation

struct TrackerRecord {
    let date: Date
    let idOfCompletedTrackers: [UUID]
    
    func addCompletedTrackerToDate(with tracker: [UUID]) -> TrackerRecord {
        return TrackerRecord(date: date, idOfCompletedTrackers: idOfCompletedTrackers + tracker)
    }
}
