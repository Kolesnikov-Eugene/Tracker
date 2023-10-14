//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import Foundation

protocol AddCategoryProtocol: AnyObject {
    
}

protocol AddCategoryDelegate: AnyObject {
    func didRecieveNewCategory(_ categoryName: String) throws
}


final class AddCategoryViewModel: AddCategoryProtocol {
    var onChange: (() -> Void)?
    var old: Int = 0
    private(set) var new: Int = 0 {
        didSet {
            onChange?()
        }
    }
    private(set) var categories: [TrackerCategoryProtocol] = []
//    private(set) var categories: [TrackerCategoryProtocol] = [] {
//        didSet {
//            onChange?()
//        }
//    }
    private lazy var dataManager: CategoriesManagerProtocol? = {
        configureDataManager()
    }()
    
    init() {
        categories = fetchAllCategoriesFromStore().sorted(by: { $0.category < $1.category })
        old = fetchAllCategoriesFromStore().count
    }
    
    private func configureDataManager() -> CategoriesManagerProtocol? {
        let dataStore = DataStore()
        do {
            try dataManager = DataManager(dataStore)
            return dataManager
        } catch {
            print("error")
            return nil
        }
    }
    
    private func fetchAllCategoriesFromStore() -> [TrackerCategoryProtocol] {
        guard let categories = try? dataManager?.fetchAllCategories() else { return [] }
        return categories
    }
}

extension AddCategoryViewModel: AddCategoryDelegate {
    func didRecieveNewCategory(_ categoryName: String) throws {
        try dataManager?.addCategory(categoryName)
        categories = fetchAllCategoriesFromStore().sorted(by: { $0.category < $1.category })
        new = categories.count
    }
}
