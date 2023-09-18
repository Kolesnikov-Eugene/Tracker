//
//  Tracker.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let type: TypeTracker
    let category: String
    let emoji: String
    let color: UIColor
    let description: String
    let schedule: [Schedule]
}
