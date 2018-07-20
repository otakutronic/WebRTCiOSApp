//
//  VideoHistoryListManager.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import UIKit
import SwiftyJSON
import PhoneNumberKit
import RealmSwift

class VideoHistoryListManager : ListManager {

    /// init
    override init(realm: Realm) {
        super.init(realm: realm)
    }
    
    /// addOrUpdateEntry
    ///
    /// - Parameter entry: <#entry description#>
    override func addOrUpdateEntry(entry: Object) {
        
        try! realm.write {
            if !(entry is VideoHistory) { return }
            
            let newHistory = entry as! VideoHistory
            
            print("\n----------------Saving chat history-----------------")
            print("id: \(newHistory.id)")
            print("contactID: \(newHistory.contactID)")
            print("date: \(newHistory.date)")
            print("state: \(newHistory.state)")
            print("length: \(newHistory.length)")
            print("----------------------------------------------------\n")
            
            realm.add(newHistory, update: false)
            print("realm.add")
        }
    }
    
    /// filter the video chat history list for an ID
    ///
    /// - Returns: <#return value description#>
    func getVideoChatHistoryList(id: String) -> Results<VideoHistory> {
        
        let predicate = NSPredicate(format: "contactID = %@", id) //.sorted("date", ascending: true)
        let list = try! Realm().objects(VideoHistory.self).filter(predicate)

        for item in list {
            let listItem = item as VideoHistory
            
            print("\n----------------Retrieveing chat history-----------------")
            print("id: \(listItem.id)")
            print("contactID: \(listItem.contactID)")
            print("date: \(listItem.date)")
            print("state: \(listItem.state)")
            print("length: \(listItem.length)")
            print("----------------------------------------------------------\n")
        }
        
        return list
    }
    
    /// gets all the history list for video chat
    ///
    /// - Returns: <#return value description#>
    func getAllVideoChatHistoryList() -> Results<VideoHistory> {
        let list = try! Realm().objects(VideoHistory.self)
        return list
    }
}
