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
    /*func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        do {
          people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
          try managedContext.save()
          people.append(person)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }*/
}
