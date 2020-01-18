//
//  AddCategoryVC.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-15.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class AddEditCategoryVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    var blurEffectView:UIVisualEffectView?
    var lblText : String?
    var categoryTxt : String?
    @IBOutlet weak var iconCollecView: UICollectionView!
    @IBOutlet weak var addCatgryTxt: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let titleTxt = lblText {
            titleLbl.text = titleTxt
        }
        if let category = categoryTxt {
            addCatgryTxt.text = category
        }
        applyPresetConstraints()
        Utilities().applyDropShadowSearchBar(addCatgryTxt)
        showAnimate()
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func onDone(_ sender: UIButton) {
        let mainVc = self.parent as! MainVC
        if let category = categoryTxt {
            mainVc.editCategory(category,addCatgryTxt.text!)
        } else  if addCatgryTxt != nil && !addCatgryTxt.text!.isEmpty {
            let mainVc = self.parent as! MainVC
            mainVc.addCategory(addCatgryTxt.text!)
        }
        removeAnimate()
    }
    
    // MARK: - Collection View Delegate functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addCatgryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! AddEditCategoryCell
        addCatgryCell.iconBtn.setBackgroundImage(UIImage(named:"shopping"), for: .normal)
        return addCatgryCell
    }
    
    // MARK: - Text field Delegate functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
}

extension AddEditCategoryVC {
    func makeBlurEffectView() {
        let effect: UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: effect)
        blurEffectView!.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        self.parent?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.parent?.view.addSubview(blurEffectView!)
        self.parent?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss() {
        removeAnimate()
    }

    func removeBlurEffectView() {
        if blurEffectView != nil {
            self.blurEffectView!.removeFromSuperview()
        }
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        makeBlurEffectView()
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.view.removeFromSuperview()
                }
        });
        removeBlurEffectView()
    }
    
    func applyPresetConstraints() {
        let layout = iconCollecView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 35, height: 35)
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        popupView.backgroundColor = .init(white: 1, alpha: 0.6)
        iconCollecView.backgroundColor = .clear
        popupView.layer.borderColor = Utilities().hexStringToUIColor(hex: "#707070").cgColor
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = Utilities().hexStringToUIColor(hex: "#3C3C434A").cgColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame = CGRect(x: 0, y: 0, width: 1, height: doneBtn.frame.height)
        
        let topBorder = CALayer()
        topBorder.borderColor = Utilities().hexStringToUIColor(hex: "#3C3C434A").cgColor
        topBorder.borderWidth = 1
        topBorder.frame = CGRect(x: 0, y: 0, width: doneBtn.frame.width, height: 1)
        
        let topBorderCancel = CALayer()
        topBorderCancel.borderColor = Utilities().hexStringToUIColor(hex: "#3C3C434A").cgColor
        topBorderCancel.borderWidth = 1
        topBorderCancel.frame = CGRect(x: 0, y: 0, width: cancelBtn.frame.width, height: 1)
        doneBtn.layer.addSublayer(topBorder)
        doneBtn.layer.addSublayer(bottomBorder)
        
        cancelBtn.layer.addSublayer(topBorderCancel)
    }
}
