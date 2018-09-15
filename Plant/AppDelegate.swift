//
//  AppDelegate.swift
//  Plant
//
//  Created by Olivia Brown on 8/19/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var servingsViewController = ServingsViewController()
    var servingsManager = ServingsManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIConstants.colors.defaultGreen
        self.window?.rootViewController = UINavigationController(rootViewController: servingsViewController)
        self.window?.makeKeyAndVisible()

        // Set original default values for max servings
        let servingsDefaults = [ServingsManager.ServingsKey.leafyVegetables: 2,
                           ServingsManager.ServingsKey.otherVegetables: 2,
                           ServingsManager.ServingsKey.berries: 1,
                           ServingsManager.ServingsKey.otherFruit: 3,
                           ServingsManager.ServingsKey.wholeGrains: 5,
                           ServingsManager.ServingsKey.legumes: 2,
                           ServingsManager.ServingsKey.nutsAndSeeds: 1]
        UserDefaults.standard.register(defaults: servingsDefaults)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ServingsData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

