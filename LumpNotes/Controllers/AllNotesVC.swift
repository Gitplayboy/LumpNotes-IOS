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
    
    var categoryName:String?
    var selectedNoteForUpdate:Notes?
    let utils = Utilities()
    var notes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = DataModel().fetchNotesForCategory(categoryName!)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        notesTableView.addGestureRecognizer(longPress)
        applyPresetConstraints()
    }
    
    @objc func handleLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: notesTableView)
            if let indexPath = notesTableView.indexPathForRow(at: touchPoint) {
                notesTableView.cellForRow(at: indexPath)
                print("index path \(indexPath)")
            }
        }
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
            let myString = formatter.string(from: note_created_timestamp)
            // For date
            let myDate = formatter.date(from: myString)
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataModel().deleteNote(categoryName!, notes[indexPath.row])
            notes.remove(at: indexPath.row)
            self.notesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNoteForUpdate = notes[indexPath.row]
        performSegue(withIdentifier: "ShowNotes", sender: nil)
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
        print("notes row record is \(notes.count)")
        notesTableView.reloadData()
        print("am called now")
    }
}
