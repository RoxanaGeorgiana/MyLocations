//
//  RealmManager.swift
//  MyLocations
//
//  Created by Puf, Roxana on 16/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import UIKit
import RealmSwift

let realmObject = try! Realm()

class RealmManager: NSObject {
    
    static let sharedInstance = RealmManager()
    
    func fetchAllObjects(_ T : Object.Type) -> [Object] {
        var objects = [Object]()
        DispatchQueue(label: "background").sync {
            autoreleasepool {
                for result in realmObject.objects(T) {
                    objects.append(result)
                }
            }
        }
        return objects
    }
    
    func delete(_ object : Object) {
        DispatchQueue(label: "background").sync {
            autoreleasepool {
                try! realmObject.write {
                    realmObject.delete(object)
                }
            }
        }
    }
    
    func deleteAllObjects() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        DispatchQueue(label: "background").sync {
            autoreleasepool {
                try! realmObject.write {
                    realmObject.deleteAll()
                }
            }
        }
    }
    
    func add(_ object : Object) {
        DispatchQueue(label: "background").sync {
            autoreleasepool {
                try! realmObject.write{
                    realmObject.add(object, update: .all)
                }
            }
        }
    }
    
    func update(_ block: @escaping () -> Void) {
        DispatchQueue(label: "background").sync {
            autoreleasepool {
                try! realmObject.write(block)
            }
        }
    }
}
