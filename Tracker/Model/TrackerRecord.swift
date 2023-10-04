//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import Foundation

protocol TrackerRecordProtocol {
    var id: UUID { get }
    var date: Date { get }
}

struct TrackerRecord: TrackerRecordProtocol {
    let id: UUID
    let date: Date
}
