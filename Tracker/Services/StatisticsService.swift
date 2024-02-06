//
//  StatisticsService.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import Foundation

protocol StatisticServiceProtocol: AnyObject {
    var statistics: [StatisticsModel] { get set }
    func fetchCompletedTrackers() -> Int
    func fetchStatistics()
}

final class StatisticService: StatisticServiceProtocol {
    //TODO: - statistics update when tracker ckecked as completed/uncompleted
    //RXSwift ?
    
    var statistics: [StatisticsModel] = []
    
    private lazy var dataManager: TrackersRecordManagerProtocol? = {
        configureDataManager()
    }()
    private var datesArray: [Date]?
    
    init() {
        fetchStatistics()
    }
    
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
    
    func fetchStatistics() {
        //function
        let completedTrackers = StatisticsModel(statName: "Трекеров завершено", value: fetchCompletedTrackers())
        statistics.append(completedTrackers)
        
        //function
        let counter = try? dataManager?.fetchCompletedTrackersCounter()
        guard let counter = counter else {
            return
        }
        var dates = counter.compactMap { tracker -> TimeInterval in
            tracker.date.timeIntervalSince1970
        }
        let days = Set(dates)
        dates = Array(days)
        dates.sort()
        
        getBestInterval(dates)
        
        let bestPeriod = StatisticsModel(statName: "Лучший период", value: UserDefaults.standard.integer(forKey: "bestInterval"))
        
        statistics.append(bestPeriod)
        
        //function
        let totalTrackers = completedTrackers.value
        let average = Int(totalTrackers) / Int(dates.count)
        let averageTrackerPerDay = StatisticsModel(statName: "Среднее значение", value: average)
        
        statistics.append(averageTrackerPerDay)
        
        //function
        getPerfectDaysCounter()
    }
    
    func fetchCompletedTrackers() -> Int {
        let counter = try? dataManager?.fetchCompletedTrackersCounter()
        
        guard let counter = counter else {
            return 0
        }
        
        return counter.count
    }
    
    func getBestInterval(_ dates: [TimeInterval]) {
        var bestInterval: Int = 0
        
        for i in 0..<dates.count {
            checkIfItsBestInterval(bestInterval)
            guard i < dates.count - 1 else {
//                print("best \(bestInterval)")
//                print("best interval: \(UserDefaults.standard.integer(forKey: "bestInterval"))")
                return
            }
            if dates[i] + 86400 == dates[i+1] {
                bestInterval += 1
            } else {
                bestInterval = 0
            }
        }
    }
    
    private func checkIfItsBestInterval(_ bestInterval: Int) {
        //TODO implement userdefaults check
        //update best interval when trackers unchecked
        let current = UserDefaults.standard.integer(forKey: "bestInterval")
//        print(current)
        if bestInterval > current {
            UserDefaults.standard.setValue(bestInterval, forKey: "bestInterval")
        }
    }
    
    private func getPerfectDaysCounter() {
        let counter = try? dataManager?.fetchCompletedTrackersCounter()
        guard let counter = counter else {
            return
        }
        var dates = counter.compactMap { tracker -> TimeInterval in
            tracker.date.timeIntervalSince1970
        }
        
        
    }
 }
