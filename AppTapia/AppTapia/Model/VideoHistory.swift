//
//  VideoHistory.swift
//  AppTapia
//
//  Created by Andy 01/10/17.
//

import Foundation
import RealmSwift
import SwiftyJSON

class VideoHistory: Object {
    
    enum CallType: String {
        case CALL_TYPE_NOREPLY = "1"
        case CALL_TYPE_MISSED = "2"
        case CALL_TYPE_INCOMINGSUCCESS = "3"
        case CALL_TYPE_INCOMINGFAILED = "4"
        case CALL_TYPE_OUTCOMINGSUCCESS = "5"
        case CALL_TYPE_OUTCOMINGFAILED = "6"
        case CALL_TYPE_MISSED_NOTIFIED = "7"
    }
    
    struct PropertyKey {
        static let id = "id"
        static let contactID = "contactID"
        static let date = "date"
        static let state = "state"
        static let length = "length"
    }
    
    @objc dynamic var id = ""
    @objc dynamic var contactID = ""
    @objc dynamic var date = ""
    @objc dynamic var state = CallType.CALL_TYPE_NOREPLY.rawValue
    @objc dynamic var length = ""
    
    //MARK: - Initializer
    convenience init(id: String, contactID: String, date: String, state: String, length: String){
        self.init()
        self.id = id
        self.contactID = contactID
        self.date = date
        self.state = state
        self.length = length
    }
    
    //MARK: NSCoding
    /// encode
    ///
    /// - Parameter aCoder: <#aCoder description#>
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(contactID, forKey: PropertyKey.contactID)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(state, forKey: PropertyKey.state)
        aCoder.encode(length, forKey: PropertyKey.length)
    }
    
    //MARK: -
    override static func primaryKey() -> String? {
        return "id"
    }
}

