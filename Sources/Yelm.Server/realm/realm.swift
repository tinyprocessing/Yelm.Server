//
//  File.swift
//  
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import RealmSwift




open class RealmCache: ObservableObject, Identifiable {
    public var id: Int = 0
    let realm : Realm
    
    
    
    init() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
         realm = try! Realm()
    }
    
    public func increment_cache() -> Int {
        return (realm.objects(CachedStrings.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    
    public func cache_read(name: String) -> String{
        let realm = try! Realm()
        let objects = realm.objects(CachedStrings.self).filter("name == '\(name)'")
        if (objects.count > 0) {
            return objects.first!.value
        }

        
        return "none"
    }
    
    public func cache_items(value: String, name: String) {
        let realm = try! Realm()
        
        let objects = realm.objects(CachedStrings.self).filter("name == '\(name)'")

        if (objects.count > 0){
            if let cache = objects.first {
                try! realm.write {
                    cache.value = value
                }
            }
            
        }else{
            let cache = CachedStrings()
            cache.id = increment_cache()
            cache.value = value
            cache.name = name
            
            
            try! realm.write {
                realm.add(cache)
            }
        }
        
    }
    
    public func delete_cache(name: String) {
        let realm = try! Realm()
        let object = realm.objects(CachedStrings.self).filter("name == '\(name)'")
        if (object.count > 0){
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    
    
}
