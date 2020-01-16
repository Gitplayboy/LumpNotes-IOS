//
//  CategoryViewCell.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

protocol CategoryViewCellDelegate: class {
    func selectedCategory(cell: CategoryViewCell)
    func appearBlackViewFrame()
}

class CategoryViewCell: UICollectionViewCell {
    var delegate: CategoryViewCellDelegate?
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    
    @IBAction func onMenuClick() {
        delegate!.selectedCategory(cell: self)
    }
    
}
