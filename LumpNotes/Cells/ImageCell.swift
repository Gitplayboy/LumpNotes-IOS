//
//  ImageCellCollectionViewCell.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

protocol ImageCellDelegate:class {
    func deleteImage(cell: ImageCell)
}

class ImageCell: UICollectionViewCell {
    var delegate: ImageCellDelegate?
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func onDeleteClick() {
        delegate?.deleteImage(cell:self)
    }
}
