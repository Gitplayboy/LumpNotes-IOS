//
//  AddEditNoteVC.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

extension UITextField {
    func setBottomBorder() {
      self.borderStyle = .none
      self.layer.backgroundColor = UIColor.white.cgColor

      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.gray.cgColor
      self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0.0
    }
}

protocol AddEditNoteDelegate:class {
    func reloadTableAtLastIndex()
}

class AddEditNoteVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,MKMapViewDelegate, UITextFieldDelegate {
    var delegate:AddEditNoteDelegate?
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var notesTitle: UITextField!
    @IBOutlet weak var notesTxt: UITextView!
    @IBOutlet weak var topView: UIView!
    var imgViewArr = [UIImageView]()
    var categoryName:String?
    var isEditNote = false
    var notesObj:Notes?
    @IBOutlet weak var imgLocationOnMap: MKMapView!
    @IBOutlet weak var locationInfo: UILabel!
    @IBOutlet weak var imgCollecView: UICollectionView!
    @IBOutlet weak var audioTableView: UITableView!
    let locManager = CLLocationManager()
    @IBOutlet weak var imgStackView: UIStackView!
    override func viewDidLoad() {
        topView.layer.cornerRadius = 20
        notesTxt.delegate = self
        super.viewDidLoad()
        self.notesTxt.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        imgLocationOnMap.delegate = self
        imgLocationOnMap.showsUserLocation = true
        notesTitle.delegate = self
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        notesTitle.setBottomBorder()
        let layout = imgCollecView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 144, height: 153)
        if isEditNote {
            populateValuesForEditing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scroller.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
    }
    
    @objc func tapDone(sender: Any) {
        self.notesTxt.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
    
    //Location code
    func centerMapOnLocation(_ location:CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        imgLocationOnMap.setRegion(coordinateRegion, animated: true)
        imgLocationOnMap.mapType = .standard
    }
    
    //Location code
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            print("user permission denied for maps")
        } else if (status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse) {
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
                let currentLocation:CLLocation = locManager.location!
                centerMapOnLocation(currentLocation)
                
                let geo = CLGeocoder()
                var addressString : String = ""
                geo.reverseGeocodeLocation(currentLocation) { placemarks, error in
                    guard let ps = placemarks, ps.count > 0 else {return}
                    if let pm = ps.first {
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        self.locationInfo.text = "Location:  \(addressString)"
                    }
                }
            }
        }
    }
    
    //Location code
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKUserLocation else { return nil }
        
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.image = UIImage(named: "pin")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    //Pictures loading code
    @IBAction func galleryAction() {
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in}
        
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cancelAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    //Pictures loading code
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgView = UIImageView()
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = selectedImage
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
                self.imgViewArr.append(imgView)
                self.imgCollecView.insertItems(at: [IndexPath(row: self.imgViewArr.count - 1, section: 0)])
                self.imgCollecView.scrollToItem(at: IndexPath(row: self.imgViewArr.count - 1, section: 0), at: .right, animated: true)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imgViewArr.count)
        return imgViewArr.count
    }
    
    @IBAction func onSaveAction(_ sender: Any) {
        if let _ = categoryName {
            
        } else {
            categoryName = "Untitled"
        }
        var imgData = [Data]()
        for imgView in imgViewArr {
            imgData.append((imgView.image?.pngData())!)
        }
        
        if !notesTitle.text!.isEmpty{
            DataModel().AddNotesForCategory(self.categoryName!, self.notesTitle.text!, self.notesTxt.text!, String(self.locManager.location!.coordinate.latitude), String(self.locManager.location!.coordinate.longitude), note_created_timestamp: Date(), imgData)
            
            delegate?.reloadTableAtLastIndex()
            self.navigationController?.popViewController(animated: true)
        } else {
            let alertCtrl = UIAlertController(title: "Cannot Save Note", message: "Please enter Note title before saving", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){(action) in}
            alertCtrl.addAction(okAction)
            self.present(alertCtrl, animated: true){}
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.delegate = self
        cell.imgView.image = imgViewArr[indexPath.row].image
        if imgViewArr.isEmpty && !imgStackView.isHidden {
            imgStackView.isHidden = true
        } else if !imgViewArr.isEmpty && imgStackView.isHidden {
            imgStackView.isHidden = false
        }
        print("the index path is \(indexPath.row)")
        return cell
    }
}

extension AddEditNoteVC: ImageCellDelegate {
    func deleteImage(cell: ImageCell) {
        let index = self.imgCollecView.indexPath(for: cell)
        self.imgCollecView.deleteItems(at: [index!])
        imgViewArr.remove(at: index!.row)
        
        if imgViewArr.isEmpty && !imgStackView.isHidden{
            imgStackView.isHidden = true
        } else if !imgViewArr.isEmpty && imgStackView.isHidden {
            imgStackView.isHidden = false
        }
    }
    
    func populateValuesForEditing() {
        if let notes = notesObj {
            notesTitle.text = notesObj?.note_title
            notesTxt.text = notesObj?.note_description
            let imgArr = notes.images?.allObjects as! [Notes_images]
            for images in imgArr {
                if let content = images.image_content {
                    imgViewArr.append(UIImageView(image: UIImage(data: content)))
                }
            }
            imgCollecView.reloadData()
        }
    }
}
