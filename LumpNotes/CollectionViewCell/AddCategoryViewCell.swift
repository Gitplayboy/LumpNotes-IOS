//
//  AddCategoryViewCell.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-15.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class AddCategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImgView:UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
