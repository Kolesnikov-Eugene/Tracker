//
//  TypeTracker.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 16.09.2023.
//

import Foundation

enum TypeTracker {
    case habit
    case irregularEvent
    
    var typeTrackerName: String {
        switch self {
        case .habit:
            return "Новая привычка"
        case .irregularEvent:
            return "Новое нерегулярное событие"
        }
    }
}
