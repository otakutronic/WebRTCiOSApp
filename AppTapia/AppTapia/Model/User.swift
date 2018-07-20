//
//  User.swift
//  tapiamobile
//
//  Created by Andy 01/09/17.
//

import Foundation
import RealmSwift

class User: Object {
    
    struct PropertyKey {
        static let id = "id"
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let profilePicture = "profilePicture"
        static let email = "email"
        static let secretQuestion = "secretQuestion"
        static let secretAnswer = "secretAnswer"
        static let password = "password"
    }
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var phoneNumber = ""
    var profilePicture = ""
    @objc dynamic var email = ""
    @objc dynamic var secretQuestion = ""
    //TODO: dont persist these.
    @objc var secretAnswer = ""
    @objc var password = ""

    let contacts = List<Contact>()
    
    //MARK: - Initializer
    convenience init(uuid: String) {
        self.init()
        self.id = uuid
    }
    
    //MARK: -
    override static func primaryKey() -> String? {
        return "id"
    }

}
