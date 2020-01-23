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
                                              height: 44.0))//
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

extension UITextField {
    func setBottomBorder() {
      self.borderStyle = .none
      self.layer.backgroundColor = UIColor.white.cgColor

      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.2
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
    var currentLocation = CLLocation()
    @IBOutlet weak var imgStackView: UIStackView!
    override func viewDidLoad() {
        topView.layer.cornerRadius = 20
        notesTxt.delegate = self
        super.viewDidLoad()
        self.notesTxt.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        imgLocationOnMap.delegate = self
        if !isEditNote {
            imgLocationOnMap.showsUserLocation = true
        }
        notesTitle.delegate = self
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        notesTitle.setBottomBorder()
        let layout = imgCollecView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 144, height: 153)
        if isEditNote {
            populateValuesForEditing()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onSaveAction(_:)))
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
                if isEditNote {
                    let latitude = Double(notesObj!.note_latitude_loc!)
                    let longitude = Double(notesObj!.note_longitude_loc!)
                    currentLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = currentLocation.coordinate
                    imgLocationOnMap.addAnnotation(annotation)
                } else {
                    currentLocation = locManager.location!
                }
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
        return imgViewArr.count
    }
    
    @IBAction func onSaveAction(_ sender: Any) {
        if categoryName == nil {
            categoryName = "Untitled"
        }
        
        if !notesTitle.text!.isEmpty {
            var imgData : [Data]?
            if imgViewArr.count > 0 {
                imgData = [Data]()
            }
            for imgView in imgViewArr {
                imgData!.append((imgView.image?.pngData())!)
            }
            if !isEditNote {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let currDate = formatter.string(from: Date())
            DataModel().AddNotesForCategory(self.categoryName!, self.notesTitle.text!, self.notesTxt.text!, String(self.locManager.location!.coordinate.latitude), String(self.locManager.location!.coordinate.longitude), note_created_timestamp: currDate, imgData)
            } else {
                notesObj?.note_title = notesTitle.text!
                notesObj?.note_description = notesTxt.text!
                do {
                    if let imgs = imgData {
                        let imgData = try NSKeyedArchiver.archivedData(withRootObject: imgs, requiringSecureCoding: false)
                        notesObj?.note_images = imgData
                    }
                    DataModel().updateNote(self.categoryName!, notesObj!)
                } catch let error as NSError {
                    print("Could not archive image to data and update note. \(error), \(error.userInfo)")
                }
            }
            
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
            if let noteImages = notes.note_images {
                let imgData = NSKeyedUnarchiver.unarchiveObject(with: noteImages)
                for images in imgData as! [Data]{
                    imgViewArr.append(UIImageView(image: UIImage(data: images)))
                }
            }
            if !imgViewArr.isEmpty {
                imgStackView.isHidden = false
            }
        }
    }
}