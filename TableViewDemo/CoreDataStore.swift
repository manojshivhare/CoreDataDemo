//
//  CoreDataStore.swift
//  TableViewDemo
//
//  Created by Manoj Shivhare on 03/04/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStore {
    
    private init() {}
    
    //Returns the current Persistent Container for CoreData
    class func getContext () -> NSManagedObjectContext {
        return CoreDataStore.persistentContainer.viewContext
    }
    
    
    static var persistentContainer: NSPersistentContainer = {
        //The container that holds both data model entities
        let container = NSPersistentContainer(name: "TableViewDemo")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
                //TODO: - Add Error Handling for Core Data
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    class func saveContext() {
        let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
                print("Data Saved to Context")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /* Support for GRUD Operations */
    
    // GET / Fetch / Requests
    class func getAllDataFromStore() -> Array<Octokit> {
        let all = NSFetchRequest<Octokit>(entityName: "Octokit")
        var allData = [Octokit]()
        
        do {
            let fetched = try CoreDataStore.getContext().fetch(all)
            allData = fetched
        } catch {
            let nserror = error as NSError
            //TODO: Handle Error
            print(nserror.description)
        }
        
        return allData
    }

}



