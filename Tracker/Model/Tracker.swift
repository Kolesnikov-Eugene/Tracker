//
//  Tracker.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

struct Tracker {
    let id: UUID?
    let date: Date?
    let type: TypeTracker
    let counter: UInt?
    let category: String
    let emoji: String
    let color: UIColor
    let description: String
    let schedule: [Schedule]
    let trackerIsDoneAt: [String]
    
    var counterLabel: String {
        switch self.counter! {
        case 0, 5...7:
            return "дней"
        case 1:
            return "день"
        case 2...4:
            return "дня"
        default:
            return "дня"
        }
    }
    
    func addCompletedDate(_ dateOfComplete: Date) -> Tracker? {
        // if the dateOfCompletion is graeter than current date, you can't mark tracker as done.
        guard let currentCounter = self.counter,
              dateOfComplete <= Date() else { return nil }
        return Tracker(
            id: id,
            date: date,
            type: type,
            counter: currentCounter + 1,
            category: category,
            emoji: emoji,
            color: color,
            description: description,
            schedule: schedule,
            trackerIsDoneAt: trackerIsDoneAt + [dateOfComplete.onlyDate]
        )
    }
    
    func removeCompletedDate(_ dateOfCompletion: String) -> Tracker {
        let currentCounter = self.counter!
        var newDates: [String] = []
        trackerIsDoneAt.forEach { date in
            if date != dateOfCompletion {
                newDates.append(date)
            }
        }
        return Tracker(
            id: id,
            date: date,
            type: type,
            counter: currentCounter - 1,
            category: category,
            emoji: emoji,
            color: color,
            description: description,
            schedule: schedule,
            trackerIsDoneAt: newDates
        )
    }
}

enum Schedule: Int, CaseIterable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
    
    func representFullDayName() -> String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    func representShortDayName() -> String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
    
    func representCountOfWeekDays() -> Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
}

extension Schedule: Comparable {
    static func < (lhs: Schedule, rhs: Schedule) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
