//
//  NotesCell.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var noteTxt: UILabel!
    @IBOutlet weak var dateLblTxt: UILabel!
    @IBOutlet weak var timeStampLblTxt: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        iconView.layer.cornerRadius = 22
    }
    
    @IBAction func onNotesEdit(_ sender: UIButton) {
        
    }
}
