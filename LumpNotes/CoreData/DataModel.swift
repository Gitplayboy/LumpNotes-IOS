//
//  DataModel.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-13.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import CoreData

class DataModel {
   
    let persistentContainer = NSPersistentContainer(name: "LumpNotes")
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    func initalizeStack() {
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }
            print("store loaded")
        }
    }
    
    func fetchData() -> [Notes]{
        var notes = [Notes]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return notes
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        do {
          notes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return notes
    }
    
    func saveData(_ title:String,_ description:String,_ location:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
            try managedContext.save()
        } catch {
            
        }
    }
    
    func addCategory() {
        
    }
}
