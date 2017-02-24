//
//  College.swift
//  College Profile
//
//  Created by MRisser1 on 2/6/17.
//  Copyright © 2017 MRisser1. All rights reserved.
//

import UIKit
import RealmSwift

class College: Object {

    dynamic var name = String()
    dynamic var location = String()
    dynamic var population = Int()
    dynamic var url = String()
    dynamic var image = Data()
    
    convenience init(name: String, location: String, population: Int, image: Data, url: String) {
        self.init()
        self.name = name
        self.location = location
        self.population = population
        self.image = image
        self.url = url
    }

}
