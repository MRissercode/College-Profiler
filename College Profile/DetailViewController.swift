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

class DetailViewController: UIViewController, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
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
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
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

}

