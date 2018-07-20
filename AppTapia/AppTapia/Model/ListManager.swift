//
//  ListManager.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import UIKit
import SwiftyJSON
import PhoneNumberKit
import RealmSwift

class ListManager {
    
    internal unowned let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    /// getList
    ///
    /// - Returns: All user's contacts
    func getList<Element: Object>(_ type: Element.Type) -> Results<Element> {
        return realm.objects(Element.self)
    }

    /// addEntry
    ///
    /// - Parameters:
    ///   - entry: Any realm object
    func addOrUpdateEntry(entry: Object) {
        try! realm.write {
            realm.add(entry, update: true)
        }
    }
    
    /// deleteEntry
    /// TODO: Re-implement it.
    func deleteEntry(entry: Object) {
        try! realm.write {
            realm.delete(entry)
        }
    }
    
    /// delete all records from realm
    func deleteAllEntries() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
