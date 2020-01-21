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
        newEntity.setValue(categoryName, forKey: "category_name")
        do {
          try managedContext.save()
            print("notes saved successfully")
        } catch let error as NSError {
          print("Could not notes. \(error), \(error.userInfo)")
        }
    }
    
    func fetchNotesForCategory(_ categoryName:String) -> [Notes] {
        var notesArrObj = [Notes]()
        var categories = [Category]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "category_name = '\(categoryName)'")
        do {
          categories = try managedContext.fetch(fetchRequest)
          if let category = categories.first {
            notesArrObj = (category.notes?.allObjects) as! [Notes]
          }
            print("array object count is \(notesArrObj.count)")
          return notesArrObj
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
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
    
    func deleteNote(_ categoryName:String,_ notesObj:Notes) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "category_name = '\(categoryName)'")
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let category = results.first {
                category.removeFromNotes(notesObj)
            }
            try managedContext.save()
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
    
    func untitledCategoryWithNote(_ categoryName:String,_ title:String,_ description:String,_ latitude:String,_ longitude:String,note_created_timestamp:Date,_ images:[Data]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext) as! Category
        let defaultCatgryIcon = UIImage(named: "default_category")?.pngData()
        category.setValue(categoryName, forKey: "category_name")
        category.setValue(defaultCatgryIcon, forKey: "category_icon")
        
        let notes_entity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: managedContext) as! Notes
        let notes_imagesEntity = NSEntityDescription.insertNewObject(forEntityName: "Notes_images", into: managedContext) as! Notes_images
        notes_entity.setValue(title, forKey: "note_title")
        notes_entity.setValue(description, forKey: "note_description")
        notes_entity.setValue(latitude, forKey: "note_latitude_loc")
        notes_entity.setValue(longitude, forKey: "note_longitude_loc")
        notes_entity.setValue(categoryName, forKey: "category_name")
        notes_entity.setValue(note_created_timestamp, forKey: "note_created_timestamp")
        
        for image in images {
            notes_imagesEntity.setValue(image, forKey: "image_content")
        }
        
        category.addToNotes(notes_entity)
        do {
            try managedContext.save()
            print("category saved successfully")
        } catch let error as NSError {
            print("Error while adding category. \(error), \(error.userInfo)")
        }
    }
    
    func AddNotesForCategory(_ categoryName:String,_ title:String,_ description:String,_ latitude:String,_ longitude:String,note_created_timestamp:Date,_ images:[Data]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "category_name = '\(categoryName)'")
        do {
          let results = try managedContext.fetch(fetchRequest)
            if let category = results.first {
                let notes_entity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: managedContext) as! Notes
                let notes_imagesEntity = NSEntityDescription.insertNewObject(forEntityName: "Notes_images", into: managedContext) as! Notes_images
                notes_entity.setValue(title, forKey: "note_title")
                notes_entity.setValue(description, forKey: "note_description")
                notes_entity.setValue(latitude, forKey: "note_latitude_loc")
                notes_entity.setValue(longitude, forKey: "note_longitude_loc")
                notes_entity.setValue(categoryName, forKey: "category_name")
                notes_entity.setValue(note_created_timestamp, forKey: "note_created_timestamp")
                
                for image in images {
                    notes_imagesEntity.setValue(image, forKey: "image_content")
                }
                notes_entity.addToImages(notes_imagesEntity)
                category.addToNotes(notes_entity)
            } else {
                untitledCategoryWithNote(categoryName, title, description, latitude, longitude, note_created_timestamp: note_created_timestamp, images)
            }
          try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
