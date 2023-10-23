//
//  StatisticsService.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import Foundation

protocol StatisticServiceProtocol: AnyObject {
    func fetchCompletedTrackers() -> Int
}

final class StatisticService: StatisticServiceProtocol {
    private lazy var dataManager: TrackersRecordManagerProtocol? = {
        configureDataManager()
    }()
    
    init() {}
    
    private func configureDataManager() -> TrackersRecordManagerProtocol? {
        let dataStore = DataStore()
        do {
            try dataManager = TrackersManager(dataStore)
            return dataManager
        } catch {
            print("error")
            return nil
        }
    }
    
    func fetchCompletedTrackers() -> Int {
        let counter = try? dataManager?.fetchCompletedTrackersCounter()
        return counter ?? 0
    }
}
