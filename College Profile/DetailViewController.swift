//
//  DetailViewController.swift
//  College Profile
//
//  Created by MRisser1 on 2/6/17.
//  Copyright © 2017 MRisser1. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices
import MapKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    let realm = try! Realm()
    
    var detailItem: College? {
        didSet {
            self.configureView()
        }
    }
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true) {
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageView.image = selectedImage
        }
    }
    
    @IBAction func onTappedSaveButton(_ sender: UIButton) {
        if let college = self.detailItem {
            try! self.realm.write ({
                college.name = collegeTextField.text!
                college.location = locationTextField.text!
                college.size = Int(sizeTextField.text!)!
                college.url = websiteTextField.text!
                college.image = UIImagePNGRepresentation(imageView.image!)!
                collegeTextField.resignFirstResponder()
                locationTextField.resignFirstResponder()
                sizeTextField.resignFirstResponder()
                websiteTextField.resignFirstResponder()
            })
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let college = self.detailItem {
            if collegeTextField != nil {
                collegeTextField.text = college.name
                locationTextField.text = college.location
                sizeTextField.text = String(college.size)
                websiteTextField.text = String(college.url)
                imageView.image = UIImage(data: college.image)
            }
        }
    }
    
    @IBAction func onTappedSafariWebpage(_ sender: UIButton) {
        let url = URL(string: websiteTextField.text!)
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func onLibraryButtonTapped(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onTapLocateCollege(_ sender: UIButton) {
        findLocation(location: collegeTextField.text!)
    }
    
    func findLocation(location: String) {
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = location
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) in
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Place Not Found.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let locations = localSearchResponse!.mapItems
            if locations.count > 1 {
                let alert = UIAlertController(title: "Select a location", message: nil, preferredStyle: .actionSheet)
                for location in locations {
                    let name = "\(location.placemark.name!), \(location.placemark.administrativeArea!)"
                    let locationAction = UIAlertAction(title: name, style: .default, handler: { (action) in
                        self.displayMap(placemark: location.placemark)
                    })
                    alert.addAction(locationAction)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.displayMap(placemark: locations.first!.placemark)
            }
        }
    }
    
    func displayMap(placemark: MKPlacemark) {
        self.navigationItem.title = placemark.name
        let center = placemark.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: center, span: span)
        let pin = MKPointAnnotation()
        pin.title = placemark.name
        mapView.addAnnotation(pin)
        self.mapView.setRegion(region, animated: true)
    }
    
}

