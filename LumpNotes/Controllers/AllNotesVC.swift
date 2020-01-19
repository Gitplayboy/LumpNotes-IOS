//
//  AllNotesVC.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class AllNotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addNotesBtn: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var categoryName:String?
    let utils = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyPresetConstraints()
    }
    
    func applyPresetConstraints() {
        addNotesBtn.layer.cornerRadius = addNotesBtn.frame.size.width/2
        addNotesBtn.layer.masksToBounds = true
        topView.layer.cornerRadius = 20
        view.backgroundColor = utils.hexStringToUIColor(hex: "#F7F7F7")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //emptyContainerView.isHidden = false
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as! NotesCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
