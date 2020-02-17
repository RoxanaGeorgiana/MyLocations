//
//  NetworkManager.swift
//  MyLocations
//
//  Created by Puf, Roxana on 15/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import Foundation
import RealmSwift

final class NetworkManager {
    
    private let urlString = "https://demo8553475.mockable.io/mylocations"
    private let realm = try! Realm()
    
    var realmManager : RealmManager = RealmManager()
    
    func fetchLocations() {
        if let url = URL(string:  urlString) {
            URLSession.shared.dataTask(with:url) { (data, response, error) in
                if let error = error {
                    print("Error while fetching locations: \(error)")
                    return
                }
                do {
                    if let dataResponse = data {
                        let json = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                        guard let jsonArray = json as? [[String: Any]] else { return }
                        for item in jsonArray {
                            self.createNewLocation(item)
                        }
                    }
                } catch {
                    print("Error loading data")
                }
            }.resume()
        }
    }
    
    func createNewLocation(_ object: [String: Any]) {
        let location = Location()
        if  let name = object["tag"],
            let address = object["address"],
            let lat = object["lat"],
            let lon = object["long"],
            let img = object["img"] {
            location.id = name as! String
            location.name = name as! String
            location.address = address as! String
            location.latitude = lat as! Double
            location.longitude = lon as! Double
            location.img = img as! String
        }
        DispatchQueue.main.async {
            self.realmManager.add(location)
        }
    }
}

