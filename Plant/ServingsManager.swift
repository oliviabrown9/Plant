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

    var servingsHistory = [DailyServing]()
    var managedContext: NSManagedObjectContext!
    let appDelegate: AppDelegate!

    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        addNewDailyServing()
    }

    func save(numServings: Int, for servingType: String) {

        guard let serving = servingsHistory.last else { return }
        serving.setValue(numServings, forKey: servingType)

        do {
            try managedContext.save()
            servingsHistory.append(serving)
        } catch let error as NSError {
            print("Failed to save with error: \(error), \(error.userInfo)")
        }
    }

    func catchUpToCurrentDate() {
        let previous = servingsHistory.last?.value(forKey: "date") as? Date
        guard let prevDay = previous, Calendar.current.isDate(prevDay, inSameDayAs:Date()) else {
            addNewDailyServing()
            return
        }
    }

    func addNewDailyServing() {
        let serving = DailyServing(context: managedContext)
        serving.setValue(0, forKey: "leafyVegetables")
        serving.setValue(0, forKey: "otherVegetables")
        serving.setValue(0, forKey: "berries")
        serving.setValue(0, forKey: "otherFruit")
        serving.setValue(0, forKey: "whole grains")
        serving.setValue(0, forKey: "legumes")
        serving.setValue(0, forKey: "nutsAndSeeds")
        serving.setValue(Date(), forKey: "date")
    }
    
}
