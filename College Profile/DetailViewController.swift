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

class DetailViewController: UIViewController {

    
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var populationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    let realm = try! Realm()
    

    func configureView() {
        // Update the user interface for the detail item.
        if let college = self.detailItem {
            if collegeTextField != nil {
                collegeTextField.text = college.name
                locationTextField.text = college.location
                populationTextField.text = String(college.population)
                websiteTextField.text = String(college.url)
                imageView.image = UIImage(data: college.image)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: College? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    @IBAction func onTappedSaveButton(_ sender: UIButton) {
        if let college = self.detailItem {
            try! self.realm.write ({
                college.name = collegeTextField.text!
                college.location = locationTextField.text!
                college.population = Int(populationTextField.text!)!
                college.url = websiteTextField.text!
                college.image = UIImagePNGRepresentation(imageView.image!)!
            })
        }
    }
    
    @IBAction func onTappedSafariWebpage(_ sender: UIButton) {
        let url = URL(string: websiteTextField.text!)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}

