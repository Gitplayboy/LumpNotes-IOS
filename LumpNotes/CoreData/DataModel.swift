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
    static var notes = [Notes]()
    static var defaultCategories = [Category]()
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    static func fetchData()-> [Notes]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        do {
          notes = try managedContext.fetch(fetchRequest)
          return notes
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func saveData(_ title:String,_ description:String,_ latitude:String,_ longitude:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: managedContext)
        newEntity.setValue(title, forKey: "note_title")
        newEntity.setValue(description, forKey: "note_description")
        newEntity.setValue(latitude, forKey: "note_latitude_loc")
        newEntity.setValue(longitude, forKey: "note_longitude_loc")
        do {
          try managedContext.save()
            print("notes saved successfully")
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
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addCategory(_ categoryName:String,_ categoryIcon:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let category = Category.init(entity: NSEntityDescription.entity(forEntityName: "Category", in:managedContext)!, insertInto: managedContext)
        category.setValue(categoryName, forKey: "category_name")
        if !categoryIcon.isEmpty {
            category.setValue(categoryIcon, forKey: "category_icon")
        }
        do {
            try managedContext.save()
            print("category saved successfully")
        } catch let error as NSError {
            print("Error while saving category. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchDefaultCategories() -> [Category]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        do {
          defaultCategories = try managedContext.fetch(fetchRequest)
          return defaultCategories
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
