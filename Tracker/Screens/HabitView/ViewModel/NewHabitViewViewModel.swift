//
//  NewHabitViewViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.12.2023.
//

import Foundation

final class NewHabitViewViewModel: NewHabitViewViewModelProtocol {
    
    //MARK: - Public properties
    var selectedCategory: String = ""
    var tracker: TrackerProtocol? = nil
    var selectedEmoji: String? = nil
    var schedule: [Schedule] = []
    
    init() {
        
    }
}
