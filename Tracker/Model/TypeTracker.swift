//
//  TypeTracker.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 16.09.2023.
//

import Foundation

enum TypeTracker {
    case habit
    case irregularIvent
    
    var typeTrackerName: String {
        switch self {
        case .habit:
            return "Новая привычка"
        case .irregularIvent:
            return "Новое нерегулярное событие"
        }
    }
}
