//
//  ContactsListManager.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import UIKit
import SwiftyJSON
import PhoneNumberKit
import RealmSwift

class ContactsListManager : ListManager {
    
    // some dummy contacts
    private var dummyList =  [
        Contact(uuid: "0", name: "Tim Burton", number: "0", state: "0", profilePicture: ""),
        Contact(uuid: "1", name: "Michael Knight", number: "1", state: "0", profilePicture: ""),
        Contact(uuid: "2", name: "Bill Gates", number: "2", state: "0", profilePicture: ""),
        Contact(uuid: "3", name: "Steve Jobs", number: "3", state: "0", profilePicture: ""),
        Contact(uuid: "4", name: "Elvis Presley", number: "4", state: "0", profilePicture: ""),
        Contact(uuid: "5", name: "Bobby Brown", number: "5", state: "0", profilePicture: ""),
        Contact(uuid: "6", name: "Elliot Alderson", number: "6", state: "0", profilePicture: "")
    ]
    
    /// init
    override init(realm: Realm) {
        super.init(realm: realm)

        //addDummyData(list: dummyList)
    }
    
    /// setList
    ///
    /// - Parameter dataObject: <#dataObject description#>
    /// - Returns: list of contacts
    func setList(dataObject: [AnyObject]) {
        
        let jsonData = JSON(dataObject)[0]
        print("Set users contacts")
        
        for(_, subJson): (String, JSON) in jsonData {
            let newContact:Contact = Contact(with: subJson)
            addOrUpdateEntry(entry: newContact)
        }
    }
    
    override func addOrUpdateEntry(entry: Object) {
        try! realm.write {
            if !(entry is Contact) { return }
            
            let newContact = entry as! Contact
            if  DataManager.currentUser.contacts.filter(NSPredicate(format: "id = %@", newContact.id)).isEmpty {
                DataManager.currentUser.contacts.append(newContact)
            } else {
                realm.add(newContact, update: true) //Only update. Just in case.
            }
        }
    }
    
    /// setListFull
    ///
    /// - Parameter dataObject: <#dataObject description#>
    /// - Returns: list of contacts
//    func setListFull(dataObject: [AnyObject]) -> Array<Contact> {
//
//        let jsonData = JSON(dataObject)[0]
//        print("Set users contacts")
//
//        for(_, subJson): (String, JSON) in jsonData {
//
//            let status:String = subJson["status"].string!
//            let permissionLevel:String = subJson["permission_level"].string!
//            let updateTime:String = subJson["update_time"].string!
//            let id:String = subJson["linked_user"].string!
//
//            print("JSON status:\(status)")
//            print("JSON permission_level:\(permissionLevel)")
//            print("JSON update_time:\(updateTime)")
//            print("JSON linked_user:\(id)")
//
//            if id != "" {
//                if ContactDao.sharedDao.isContactExist(number: id) {
//                    print("ContactExist")
//
//                } else {
////                    for missContact in self.missingList {
////                        if missContact.number == remoteNumber {
////                            missContact.number = remoteNumber
////                            missContact.name = name
////                            ContactDao.sharedDao.insert(box: missContact)
////                            break
////                        }
////                    }
//                }
//            }
//        }
//        return missingList
//    }
    
    /// filter the contacts list for video chat
    ///
    /// - Returns: <#return value description#>
    func getVideoChatList() -> Results<Contact> {
        
        // filter Contacts With Status "8" // Master
        // & Contacts With Status "7" // Subuser
        // & Contacts With Status "6" // Freeuser
        
        // list = list.filter { $0.pets.contains(where: { petArr.contains($0) }) }
        
        return getList(Contact.self)
    }
    
    /// filter the contacts list for album
    ///
    /// - Returns: <#return value description#>
    func getAlbumList() -> Results<Contact> {
        
        // filter Contacts With Status "8" // Master
        // & Contacts With Status "7" // Subuser
        
        // list = list.filter { $0.pets.contains(where: { petArr.contains($0) }) }
        
        return getList(Contact.self)
    }

    /// filter the contacts list for links
    ///
    /// - Returns: <#return value description#>
    func getLinksList() -> Results<Contact> {
        return getList(Contact.self)
    }
    
    /// addDummyData
    func addDummyData(list: Array<Contact>) {
        
        super.deleteAllEntries()
        
        for (index,element) in list.enumerated() {
            let newContact:Contact = element
            let realm = try! Realm()
            try! realm.write {
                realm.add(newContact)
            }
        }
    }

    /// filter the contacts list for monitor
    ///
    /// - Returns: <#return value description#>
    func getMonitorList() -> Results<Contact> {
        
        return getList(Contact.self)
        //TODO: uncomment this line when have data
//        return getList().filter("status == '7' OR status == '8'").sorted(byKeyPath: "status")
    }
}
