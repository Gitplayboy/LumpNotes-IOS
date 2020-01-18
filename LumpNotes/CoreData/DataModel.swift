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
    
    func saveNotes(_ categoryName:String,_ title:String,_ description:String,_ latitude:String,_ longitude:String) {
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
          print("Could not notes. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete all data. \(error), \(error.userInfo)")
        }
    }
    
    func addCategory(_ categoryId:Int,_ categoryName:String,_ categoryIcon:Data?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext)
        category.setValue(categoryName, forKey: "category_name")
        category.setValue(categoryId, forKey: "category_id")
        category.setValue(categoryIcon, forKey: "category_icon")
        do {
            try managedContext.save()
            print("category saved successfully")
        } catch let error as NSError {
            print("Error while adding category. \(error), \(error.userInfo)")
        }
    }
        
     func fetchCategories() -> [Category]{
        var defaultCategories = [Category]()
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
    
    func deleteCategory(_ categoryName:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? Category else {continue}
                print("object data is \(objectData.category_name!)")
                if (objectData.category_name!.elementsEqual(categoryName)) {
                    managedContext.delete(objectData)
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func updateCategory(_ categoryName:String,_ updatedCategoryName:String,_ categoryIcon:Data?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "category_name = '\(categoryName)'")
        do {
          let results = try managedContext.fetch(fetchRequest)
          if let category = results.first {
            category.category_name = updatedCategoryName
            if let icon = categoryIcon {
                category.category_icon = icon
            }
          }
          try managedContext.save()
        } catch let error as NSError {
          print(error.localizedDescription)
        }
    }
}
