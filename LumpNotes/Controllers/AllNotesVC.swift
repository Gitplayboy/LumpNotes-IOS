//
//  AllNotesVC.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class AllNotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource,AddEditNoteDelegate {
    
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addNotesBtn: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var categories:[String]?
    var categoryName:String?
    var selectedNoteForUpdate:Notes?
    let utils = Utilities()
    var notes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = DataModel().fetchNotesForCategory(categoryName!)
        applyPresetConstraints()
    }
    
    func applyPresetConstraints() {
        addNotesBtn.layer.cornerRadius = addNotesBtn.frame.size.width/2
        addNotesBtn.layer.masksToBounds = true
        topView.layer.cornerRadius = 20
        view.backgroundColor = utils.hexStringToUIColor(hex: "#F7F7F7")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.count < 1 {
            emptyContainerView.isHidden = false
        } else {
            emptyContainerView.isHidden = true
        }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as! NotesCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let note_created_timestamp = notes[indexPath.row].note_created_timestamp {
            let myDate = formatter.date(from: note_created_timestamp)
            formatter.dateFormat = "dd-MMM-yyyy"
            let date = formatter.string(from: myDate!)
            cell.dateLblTxt.text = date
            
            //For time
            formatter.timeStyle = .short
            let timeString = formatter.string(from: myDate!)
            cell.timeStampLblTxt.text = timeString
        }
        cell.noteTxt.text = notes[indexPath.row].note_title!
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete",
          handler: { (action, view, completionHandler) in
          DataModel().deleteNote(self.categoryName!, self.notes[indexPath.row])
          self.notes.remove(at: indexPath.row)
          self.notesTableView.deleteRows(at: [indexPath], with: .fade)
          completionHandler(true)
        })
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            UIImage(named: "trash")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))
        }
        deleteAction.backgroundColor = .red
        
        if categories!.count > 1 {
            let moveAction = UIContextualAction(style: .normal, title: "Move",
              handler: { (action, view, completionHandler) in
                let alertController = UIAlertController(title: "Move Notes", message: "Select a category for moving the note", preferredStyle: .actionSheet)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in}
                alertController.addAction(cancelAction)
                
                if let categoryArr = self.categories {
                    for category in categoryArr {
                        if !self.categoryName!.elementsEqual(category) {
                            let moveNote = UIAlertAction(title: category, style: .default) { (action) in
                                DataModel().moveNoteToCategory(self.categoryName!, self.notes[indexPath.row], category)
                                self.notes.remove(at: indexPath.row)
                                self.notesTableView.deleteRows(at: [indexPath], with: .fade)
                            }
                            alertController.addAction(moveNote)
                        }
                    }
                }
                self.present(alertController, animated: true) {}
              completionHandler(true)
            })
            moveAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
                UIImage(named: "move")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))
            }
            moveAction.backgroundColor = .blue
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction,moveAction])
            return configuration
        } else {
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNoteForUpdate = notes[indexPath.row]
        performSegue(withIdentifier: "ShowNotes", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNotes" {
            let segueDest = segue.destination as! AddEditNoteVC
            segueDest.categoryName = categoryName
            segueDest.delegate = self
            segueDest.isEditNote = true
            segueDest.notesObj = selectedNoteForUpdate
        } else if segue.identifier == "addNewNote" {
            let segueDest = segue.destination as! AddEditNoteVC
            segueDest.categoryName = categoryName
            segueDest.delegate = self
        }
    }
    
    @IBAction func onCreateNewNote(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewNote", sender: nil)
    }
    
    func reloadTableAtLastIndex() {
        notes = DataModel().fetchNotesForCategory(categoryName!)
        notesTableView.reloadData()
    }
}
