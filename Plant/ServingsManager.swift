//
//  DailyServing.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ServingsManager {

    struct AverageServing {
        var leafyVegetables: Double
        var otherVegetables: Double
        var berries: Double
        var otherFruit: Double
        var wholeGrains: Double
        var legumes: Double
        var nutsAndSeeds: Double
        var totalCompleted: Int

        init(leafyVegetables: Double, otherVegetables: Double, berries: Double, otherFruit: Double,
             wholeGrains: Double, legumes: Double, nutsAndSeeds: Double, totalCompleted: Int) {
            self.leafyVegetables = leafyVegetables
            self.otherVegetables = otherVegetables
            self.berries = berries
            self.otherFruit = otherFruit
            self.wholeGrains = wholeGrains
            self.legumes = legumes
            self.nutsAndSeeds = nutsAndSeeds
            self.totalCompleted = totalCompleted
        }
    }

    let allServingTypes: [ServingType] = [
        ServingTypes().leafyVegetables(),
        ServingTypes().otherVegetables(),
        ServingTypes().berries(),
        ServingTypes().otherFruit(),
        ServingTypes().wholeGrains(),
        ServingTypes().legumes(),
        ServingTypes().nutsAndSeeds()
    ]

    private var servingsHistory = [DailyServing]()
    private var managedContext: NSManagedObjectContext? = nil
    private var appDelegate: AppDelegate? = nil

    func addServing(to currentServings: Int16, for servingType: String) {
        guard let serving = servingsHistory.last else { return }
        print(serving.leafyVegetables)
        var addedServing = currentServings + 1
        print(addedServing)
        if addedServing > getMaxServings(for: servingType) {
            addedServing = 0
        }
        serving.setValue(addedServing, forKey: servingType)
        save()
    }

    func getMaxServings(for servingType: String) -> Int {
        return UserDefaults.standard.integer(forKey: servingType)
    }

    func getCurrServings(for key: String) -> Int16 {
        guard let currServings = fetchToday() else { fatalError() }
        let types = ServingTypes()
        switch key {
        case types.leafyVegetables().key: return currServings.leafyVegetables
        case types.otherVegetables().key: return currServings.otherVegetables
        case types.berries().key: return currServings.berries
        case types.otherFruit().key: return currServings.otherFruit
        case types.wholeGrains().key: return currServings.wholeGrains
        case types.legumes().key: return currServings.legumes
        case types.nutsAndSeeds().key: return currServings.nutsAndSeeds
        default: fatalError()
        }
    }

    func getAverageServings(for key: String) -> Double {
        let averageServings = fetchWeeklyAverage()
        let types = ServingTypes()
        switch key {
        case types.leafyVegetables().key: return averageServings.leafyVegetables
        case types.otherVegetables().key: return averageServings.otherVegetables
        case types.berries().key: return averageServings.berries
        case types.otherFruit().key: return averageServings.otherFruit
        case types.wholeGrains().key: return averageServings.wholeGrains
        case types.legumes().key: return averageServings.legumes
        case types.nutsAndSeeds().key: return averageServings.nutsAndSeeds
        default: fatalError()
        }
    }

    private func save() {
        do {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            managedContext = appDelegate?.persistentContainer.viewContext
            try managedContext?.save()
        } catch let error as NSError {
            print("Failed to save with error: \(error), \(error.userInfo)")
        }
    }

    private func fetchToday() -> DailyServing? {
        loadHistory()
        let prevServings = servingsHistory.first?.date
        if prevServings == nil || !Calendar.current.isDate(prevServings!, inSameDayAs:Date()) {
            addNewDailyServing()
        }
        return servingsHistory.last
    }

    private func loadHistory() {
        let request: NSFetchRequest<DailyServing> = DailyServing.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        do {
            try servingsHistory = managedContext.fetch(request)
        } catch {
            print("Could not load data")
        }
    }

    private func addNewDailyServing() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let serving = DailyServing(context: managedContext)
        allServingTypes.forEach { serving.setValue(0, forKey: $0.key) }
        servingsHistory.append(serving)
        save()
    }

    func fetchWeeklyAverage() -> AverageServing {
        var averageDict = [String:Double]()
        allServingTypes.forEach { averageDict[$0.key] = calculateAverage(for: $0.key) }
        var totalCompleted = 0.0
        allServingTypes.forEach { totalCompleted += averageDict[$0.key]! }
        var totalPossible = 0.0
        allServingTypes.forEach { totalPossible += Double(getMaxServings(for: $0.key)) }

        return AverageServing(leafyVegetables: averageDict["leafyVegetables"]!,
                              otherVegetables: averageDict["otherVegetables"]!,
                              berries: averageDict["berries"]!,
                              otherFruit: averageDict["otherFruit"]!,
                              wholeGrains: averageDict["wholeGrains"]!,
                              legumes: averageDict["legumes"]!,
                              nutsAndSeeds: averageDict["nutsAndSeeds"]!,
                              totalCompleted: Int(totalCompleted/totalPossible * 100))
    }

    private func calculateAverage(for type: String) -> Double {
        let lastSevenDailyServings = servingsHistory.suffix(8)
        let lastWeekDates = getLastWeekDates()
        var averageServing = 0.0
        let types = ServingTypes()

        for day in lastWeekDates {
            for serving in lastSevenDailyServings {
                guard let servingDate = serving.date else { return 0.0 }
                if Calendar.current.isDate(day, inSameDayAs: servingDate) {
                    switch type {
                    case types.leafyVegetables().key: averageServing += Double(serving.leafyVegetables)
                    case types.otherVegetables().key: averageServing += Double(serving.otherVegetables)
                    case types.berries().key: averageServing += Double(serving.berries)
                    case types.otherFruit().key: averageServing += Double(serving.otherFruit)
                    case types.wholeGrains().key: averageServing += Double(serving.wholeGrains)
                    case types.legumes().key: averageServing += Double(serving.legumes)
                    case types.nutsAndSeeds().key: averageServing += Double(serving.nutsAndSeeds)
                    default: break
                    }
                }
            }
        }
        return averageServing / Double(7)
    }

    private func getLastWeekDates() -> [Date] {
        let calendar = Calendar.current
        var startDate = Date()
        var lastWeekDates = [Date]()
        for _ in 1...7 {
            guard let nextDay = calendar.date(byAdding: .day, value: -1, to: startDate) else { fatalError() }
            lastWeekDates.append(nextDay)
            startDate = nextDay
        }
        return lastWeekDates
    }

}
