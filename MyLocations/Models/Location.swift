//
//  Location.swift
//  MyLocations
//
//  Created by Puf, Roxana on 15/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object  {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var img = ""
    @objc dynamic var address = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
