//
//  ViewController.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar:UITextField!
    @IBOutlet weak var addCategoryBtn: UIButton!
    @IBOutlet weak var collecView:UICollectionView!
    var isAscendingSort = false
    let utils = Utilities()
    let reuseIdentifier = "CategoryCell" 
    var items = ["Shopping","Travelling","Education","Market","Shopping","Travelling","Education","Market"]
    var filteredCategories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        filteredCategories = items
        applyPresetConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Collection View Delegate functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryViewCell
        categoryCell.categoryLbl.text! = filteredCategories[indexPath.row]
        categoryCell.backgroundColor = utils.hexStringToUIColor(hex: "#ffffff")
        
        categoryCell.iconView.layer.cornerRadius = categoryCell.iconView.frame.size.width/2
        categoryCell.iconView.layer.masksToBounds = true
        categoryCell.iconView.backgroundColor = .random
        
        utils.applyDropShadowCollectionCell(categoryCell)
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    // MARK: - Text field Delegate functions
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchBar.text != nil && !searchBar.text!.isEmpty {
            filteredCategories = []
            for item in items {
                if item.lowercased().hasPrefix(searchBar!.text!.lowercased()) {
                    filteredCategories.append(item)
                }
            }
        } else {
            filteredCategories = items
        }
        collecView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   
      textField.resignFirstResponder()
      return true
    }
    
    @IBAction func onAddCategoryClick(_ sender: UIButton) {
        let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "sbPopupId") as! AddCategoryVC
        self.addChild(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
    }
    
    
    @IBAction func onSortBtnClick(_ sender: UIButton) {
        if isAscendingSort {
            filteredCategories.sort(){$0 > $1}
            isAscendingSort = false
        } else {
            filteredCategories.sort(){$0 < $1}
            isAscendingSort = true
        }
        items = filteredCategories
        collecView.reloadData()
    }
}

extension MainVC {
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func addCategory(_ category:String) {
        items.append(category)
        filteredCategories = items
        collecView.reloadData()
    }
    
    func applyPresetConstraints() {
        utils.applyDropShadowSearchBar(searchBar)
        topView.layer.cornerRadius = 20
        let layout = collecView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 160, height: 160)
        addCategoryBtn.layer.cornerRadius = addCategoryBtn.frame.size.width/2
        addCategoryBtn.layer.masksToBounds = true
        collecView.backgroundColor = utils.hexStringToUIColor(hex: "#F7F7F7")
        view.backgroundColor = utils.hexStringToUIColor(hex: "#F7F7F7")
    }
}

