//
//  Tracker.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

protocol TrackerProtocol {
    var id: UUID { get }
    var emoji: String { get }
    var color: UIColor { get }
    var description: String { get }
    var schedule: [Schedule] { get }
    func fetchNumberOfWeekDaysArray() -> String
}

struct Tracker: TrackerProtocol {
    let id: UUID
    let emoji: String
    let color: UIColor
    let description: String
    let schedule: [Schedule]
}
//create a new table with number of days in CoreData
extension Tracker {
    func fetchNumberOfWeekDaysArray() -> String {
        schedule.map { $0.representFullDayName() }.joined(separator: ", ")
    }
}
