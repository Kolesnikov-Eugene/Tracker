//
//  NewHabitViewViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.12.2023.
//

import Foundation
import UIKit

final class NewHabitViewViewModel: NewHabitViewViewModelProtocol {
    
    //MARK: - Public properties
    var selectedCategory: String = ""
    var tracker: TrackerProtocol? = nil
    var selectedEmoji: String? = nil
    var schedule: [Schedule] = []
    var selectedColor: UIColor? = nil
    var editingModeIsOn: Bool = false
    private var trackerEdit: TrackerEdit? = nil
    
    init() {
        print("NewHabitViewViewModel for new tracker created")
    }
    
    init(trackerEdit: TrackerEdit?) {
        if let trackerEdit = trackerEdit {
            self.trackerEdit = trackerEdit
            self.tracker = trackerEdit.tracker
            self.selectedCategory = trackerEdit.category
            self.selectedEmoji = trackerEdit.tracker.emoji
            self.selectedColor = trackerEdit.tracker.color
            self.schedule = trackerEdit.tracker.schedule
            self.editingModeIsOn = true
        } else {
            self.editingModeIsOn = false
        }
    }
    
    func allFieldsFilledOut(event: TypeTracker, trackerName: String?) -> Bool {
        if event == .irregularEvent {
            schedule = Schedule.allCases.map { $0 }
        }
        guard let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor,
              let text = trackerName,
              !selectedCategory.isEmpty,
              selectedCategory.count > 0,
              !selectedCategory.starts(with: " "),
              text.count > 0 ,
              !schedule.isEmpty
        else {
            return false
        }
        let id = editingModeIsOn ? tracker?.id : UUID()
        
        tracker = Tracker(
            id: id ?? UUID(),
            emoji: selectedEmoji,
            color: selectedColor,
            description: text,
            schedule: schedule
        )
        return true
    }
}
