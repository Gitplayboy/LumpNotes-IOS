//
//  Utilities.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-13.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class Utilities {
    let blackView = UIView()
    func hexStringToUIColor (hex:String) -> UIColor {
       var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

       if (cString.hasPrefix("#")) {
           cString.remove(at: cString.startIndex)
       }

       if ((cString.count) != 6) {
           return UIColor.gray
       }

       var rgbValue:UInt64 = 0
       Scanner(string: cString).scanHexInt64(&rgbValue)

       return UIColor(
           red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
           green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
           blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
           alpha: CGFloat(1.0)
       )
    }
    
    func applyDropShadowSearchBar(_ searchBar:UITextField) {
        //Basic texfield Setup
          searchBar.borderStyle = .roundedRect
          searchBar.backgroundColor = UIColor.white // Use anycolor that give you a 2d look.

          //To apply Shadow
          searchBar.layer.shadowOpacity = 0.5
          searchBar.layer.shadowRadius = 3.0
          searchBar.layer.shadowOffset = CGSize.zero // Use any CGSize
          searchBar.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func applyDropShadowCollectionCell(_ categoryCell:UICollectionViewCell) {
        categoryCell.layer.shadowColor = UIColor.black.cgColor
        categoryCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        categoryCell.layer.shadowRadius = 3.0
        categoryCell.layer.shadowOpacity = 0.5
        categoryCell.layer.masksToBounds = false
        categoryCell.layer.shadowPath = UIBezierPath(roundedRect: categoryCell.bounds, cornerRadius: categoryCell.layer.cornerRadius).cgPath
    }
    
    func loadPropertyList() -> [String]{
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
           nsDictionary = NSDictionary(contentsOfFile: path)
        }
        if nsDictionary != nil {
            let categoryArr = nsDictionary?.value(forKey: "Notes Category") as! [String]
            
            //If the category is empty in DB save it in from the plist
            DispatchQueue.main.async {
                for category in categoryArr {
                    DataModel().addCategory(category,"")
                }
            }
            return categoryArr
        }
        return []
    }
    
    func fetchCategoriesCoreData() -> [String]{
        var categoryArr = [String]()
        if let categoryArrObj = MainVC.categoryObj {
            for categories in categoryArrObj {
                categoryArr.append(categories.category_name!)
            }
        }
        if categoryArr.isEmpty {
            return loadPropertyList()
        }
        return categoryArr
    }
    
    
}
