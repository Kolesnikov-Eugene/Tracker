//
//  NewHabitViewViewModelProtocol.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.12.2023.
//

import Foundation

protocol NewHabitViewViewModelProtocol {
    var selectedCategory: String { get set }
    var tracker: TrackerProtocol? { get set }
    var selectedEmoji: String? { get set }
    var schedule: [Schedule] { get set }
    var editingModeIsOn: Bool { get set }
    
    func allFieldsFilledOut(event: TypeTracker, trackerName: String?) -> Bool
}
