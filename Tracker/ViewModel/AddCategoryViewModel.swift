//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import Foundation

protocol AddCategoryProtocol: AnyObject {
    func deleteCategory(_ category: String)
}

protocol AddCategoryDelegate: AnyObject {
    func didRecieveCategory(_ categoryName: String, for oldCategory: String, mode: Editing) throws
}

final class AddCategoryViewModel: AddCategoryProtocol {
    private var category: String = ""
    private(set) var categories: [TrackerCategoryProtocol] = [] {
        didSet {
            onChange?(category)
        }
    }
    private lazy var dataManager: CategoriesManagerProtocol? = {
        configureDataManager()
    }()
    var onChange: ((String) -> Void)?
    
    init() {
        categories = fetchAllCategoriesFromStore()
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
    
    func deleteCategory(_ category: String) {
        try? dataManager?.deleteCategory(category)
        categories = fetchAllCategoriesFromStore()
    }
}

extension AddCategoryViewModel: AddCategoryDelegate {
    func didRecieveCategory(_ categoryName: String, for oldCategory:String, mode: Editing) throws {
        category = categoryName
        switch mode {
        case .add:
            try dataManager?.addCategory(categoryName)
        case .rename:
            try dataManager?.renameCategory(categoryName, for: oldCategory)
        }
        
        categories = fetchAllCategoriesFromStore()
    }
}
