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

        init(leafyVegetables: Double, otherVegetables: Double, berries: Double, otherFruit: Double,
             wholeGrains: Double, legumes: Double, nutsAndSeeds: Double) {
            self.leafyVegetables = leafyVegetables
            self.otherVegetables = otherVegetables
            self.berries = berries
            self.otherFruit = otherFruit
            self.wholeGrains = wholeGrains
            self.legumes = legumes
            self.nutsAndSeeds = nutsAndSeeds
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

        do {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            managedContext = appDelegate?.persistentContainer.viewContext
            try managedContext?.save()
        } catch let error as NSError {
            print("Failed to save with error: \(error), \(error.userInfo)")
        }
    }

    private func catchUpToCurrentDate() {
        guard let previous = servingsHistory.last, Calendar.current.isDate(previous.date!, inSameDayAs:Date()) else {
            addNewDailyServing()
            return
        }
    }

    private func getMaxServings(for servingType: String) -> Int {
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
        if servingsHistory.last == nil {
            catchUpToCurrentDate()
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
        serving.setValue(0, forKey: "leafyVegetables")
        serving.setValue(0, forKey: "otherVegetables")
        serving.setValue(0, forKey: "berries")
        serving.setValue(0, forKey: "otherFruit")
        serving.setValue(0, forKey: "wholeGrains")
        serving.setValue(0, forKey: "legumes")
        serving.setValue(0, forKey: "nutsAndSeeds")
        serving.setValue(Date(), forKey: "date")
        servingsHistory.append(serving)
    }

    func fetchWeeklyAverage() -> AverageServing {
        return AverageServing(leafyVegetables: getAverage(for: "leafyVegetables"),
                              otherVegetables: getAverage(for: "otherVegetables"),
                              berries: getAverage(for: "berries"),
                              otherFruit: getAverage(for: "otherFruit"),
                              wholeGrains: getAverage(for: "wholeGrains"),
                              legumes: getAverage(for: "legumes"),
                              nutsAndSeeds: getAverage(for: "nutsAndSeeds"))
    }

    private func getAverage(for type: String) -> Double {
        let lastSevenDailyServings = servingsHistory.suffix(7)
        let lastWeekDates = getLastWeekDates()
        var averageServing = 0.0

        for day in lastWeekDates {
            for serving in lastSevenDailyServings {
                if Calendar.current.isDate(day, inSameDayAs:serving.date!) {
                    averageServing += Double(serving.berries)
                }
            }
        }
        return averageServing
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
