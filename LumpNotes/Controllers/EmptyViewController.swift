//
//  EmptyViewController.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-18.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utilities().hexStringToUIColor(hex: "#F7F7F7")
        view.isHidden = false
    }
}
