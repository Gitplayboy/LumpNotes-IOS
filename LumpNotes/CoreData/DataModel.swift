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
    
    func updateNote(_ categoryName:String,_ notesObj:Notes) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "category_name = '\(categoryName)' AND note_title = '\(String(describing: notesObj.note_title))' AND note_created_timestamp = '\(String(describing: notesObj.note_created_timestamp))'")
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let category = results.first {
                category.note_title = notesObj.note_title
                category.note_description = notesObj.note_description
                category.note_latitude_loc = notesObj.note_latitude_loc
                category.note_longitude_loc = notesObj.note_longitude_loc
                category.category_name = notesObj.category_name
                category.note_created_timestamp = notesObj.note_created_timestamp
                category.note_images = notesObj.note_images
                category.note_audios = notesObj.note_audios
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
    
    func untitledCategoryWithNote(_ categoryName:String,_ title:String,_ description:String,_ latitude:String,_ longitude:String,_ note_created_timestamp:String,_ images:[Data]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext) as! Category
        let defaultCatgryIcon = UIImage(named: "default_category")?.pngData()
        category.setValue(categoryName, forKey: "category_name")
        category.setValue(defaultCatgryIcon, forKey: "category_icon")
        
        let notes_entity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: managedContext) as! Notes
        notes_entity.setValue(title, forKey: "note_title")
        notes_entity.setValue(description, forKey: "note_description")
        notes_entity.setValue(latitude, forKey: "note_latitude_loc")
        notes_entity.setValue(longitude, forKey: "note_longitude_loc")
        notes_entity.setValue(categoryName, forKey: "category_name")
        notes_entity.setValue(note_created_timestamp, forKey: "note_created_timestamp")
        do {
            if let img = images {
                let imgData = try NSKeyedArchiver.archivedData(withRootObject: img, requiringSecureCoding: false)
                notes_entity.setValue(imgData, forKey: "note_images")
            }
        } catch let error as NSError {
            print("Error while adding Note. \(error), \(error.userInfo)")
        }
        
        category.addToNotes(notes_entity)
        do {
            try managedContext.save()
            print("category saved successfully")
        } catch let error as NSError {
            print("Error while adding Note. \(error), \(error.userInfo)")
        }
    }
    
    func addNotesForCategory(_ categoryName:String,_ title:String,_ description:String,_ latitude:String,_ longitude:String,_ note_created_timestamp:String,_ images:[Data]?) {
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
                notes_entity.setValue(title, forKey: "note_title")
                notes_entity.setValue(description, forKey: "note_description")
                notes_entity.setValue(latitude, forKey: "note_latitude_loc")
                notes_entity.setValue(longitude, forKey: "note_longitude_loc")
                notes_entity.setValue(categoryName, forKey: "category_name")
                notes_entity.setValue(note_created_timestamp, forKey: "note_created_timestamp")
                do {
                    if let img = images {
                        let imgData = try NSKeyedArchiver.archivedData(withRootObject: img, requiringSecureCoding: false)
                        notes_entity.setValue(imgData, forKey: "note_images")
                    }
                } catch let error as NSError {
                    print("Error while adding Note. \(error), \(error.userInfo)")
                }
                category.addToNotes(notes_entity)
            } else {
                untitledCategoryWithNote(categoryName, title, description, latitude, longitude,  note_created_timestamp, images)
            }
          try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func moveNoteToCategory(_ oldCategoryName:String,_ noteObj:Notes,_ newCategoryName:String) {
        deleteNote(oldCategoryName, noteObj)
        var imgData:[Data]?
        if let noteImages = noteObj.note_images {
            imgData = NSKeyedUnarchiver.unarchiveObject(with: noteImages) as? [Data]
        }
        addNotesForCategory(newCategoryName, noteObj.note_title!, noteObj.note_description!, noteObj.note_latitude_loc!, noteObj.note_longitude_loc!,  noteObj.note_created_timestamp!, imgData != nil ? imgData : nil)
    }
}
