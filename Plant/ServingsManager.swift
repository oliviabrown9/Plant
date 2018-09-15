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
    struct defaultMaxServings {
        static let leafyVegetables = 2
        static let otherVegetables = 2
        static let berries = 1
        static let otherFruit = 3
        static let wholeGrains = 5
        static let legumes = 2
        static let nutsAndSeeds = 1
    }

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

    var servingsHistory = [DailyServing]()
    private var managedContext: NSManagedObjectContext? = nil
    private var appDelegate: AppDelegate? = nil

    func addServing(to currentServings: Int16, for servingType: String) {
        guard let serving = servingsHistory.last else { return }
        var addedServing = currentServings + 1
        if addedServing > getMaxServings(for: servingType) {
            addedServing = 0
        }
        serving.setValue(addedServing, forKey: servingType)
        save()
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

    func getMaxServings(for servingType: String) -> Int {
        switch servingType {
        case "leafyVegetables":
            return defaultMaxServings.leafyVegetables
        case "otherVegetables":
            return defaultMaxServings.otherVegetables
        case "berries":
            return defaultMaxServings.berries
        case "otherFruit":
            return defaultMaxServings.otherFruit
        case "wholeGrains":
            return defaultMaxServings.wholeGrains
        case "legumes":
            return defaultMaxServings.legumes
        case "nutsAndSeeds":
            return defaultMaxServings.nutsAndSeeds
        default:
            return 0
        }
    }

    func fetchToday() -> DailyServing? {
        loadHistory()
        let prevServings = servingsHistory.first?.date
        if prevServings == nil, !Calendar.current.isDate(prevServings!, inSameDayAs:Date()) {
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
        serving.setValue(2, forKey: "leafyVegetables")
        serving.setValue(2, forKey: "otherVegetables")
        serving.setValue(2, forKey: "berries")
        serving.setValue(2, forKey: "otherFruit")
        serving.setValue(2, forKey: "wholeGrains")
        serving.setValue(2, forKey: "legumes")
        serving.setValue(2, forKey: "nutsAndSeeds")
        serving.setValue(Date(), forKey: "date")
        servingsHistory.append(serving)
        save()
    }

    func fetchWeeklyAverage() -> AverageServing {
        let leafyVegetables = getAverage(for: "leafyVegetables")
        let otherVegetables = getAverage(for: "otherVegetables")
        let berries = getAverage(for: "berries")
        let otherFruit = getAverage(for: "otherFruit")
        let wholeGrains = getAverage(for: "wholeGrains")
        let legumes = getAverage(for: "legumes")
        let nutsAndSeeds = getAverage(for: "nutsAndSeeds")
        let totalCompleted = leafyVegetables + otherVegetables + berries + otherFruit + wholeGrains + legumes + nutsAndSeeds

        let allPossibleTypes = ["leafyVegetables", "otherVegetables", "berries", "otherFruit", "wholeGrains", "legumes", "nutsAndSeeds"]
        var totalPossible = 0.0
        allPossibleTypes.forEach { totalPossible += Double(getMaxServings(for: $0)) }

        return AverageServing(leafyVegetables: leafyVegetables,
                              otherVegetables: otherVegetables,
                              berries: berries,
                              otherFruit: otherFruit,
                              wholeGrains: wholeGrains,
                              legumes: legumes,
                              nutsAndSeeds: nutsAndSeeds,
                              totalCompleted: Int(totalCompleted/totalPossible * 100))
    }

    private func getAverage(for type: String) -> Double {
        let lastSevenDailyServings = servingsHistory.suffix(8)
        let lastWeekDates = getLastWeekDates()
        var averageServing = 0.0

        for day in lastWeekDates {
            for serving in lastSevenDailyServings {
                if Calendar.current.isDate(day, inSameDayAs:serving.date!) {
                    switch type {
                    case "leafyVegetables":
                        averageServing += Double(serving.leafyVegetables)
                    case "otherVegetables":
                        averageServing += Double(serving.otherVegetables)
                    case "berries":
                        averageServing += Double(serving.berries)
                    case "otherFruit":
                        averageServing += Double(serving.otherFruit)
                    case "wholeGrains":
                        averageServing += Double(serving.wholeGrains)
                    case "legumes":
                        averageServing += Double(serving.legumes)
                    case "nutsAndSeeds":
                        averageServing += Double(serving.nutsAndSeeds)
                    default:
                        break
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
