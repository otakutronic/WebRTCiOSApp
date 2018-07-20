//
//  Contact.swift
//  tapiamobile
//
//  Created by Andy 01/09/17.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Contact: Object {
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contacts")
    
    struct PropertyKey {
        static let id = "id"
        static let state = "state"
        static let name = "name"
        static let number = "number"
        static let profilePicture = "profilePicture"
        static let status = "status"
        static let permissionLevel = "permissionLevel"
        static let updateTime = "updateTime"
        static let deviceType = "deviceType"
        static let linkedUser = "linkedUser"
        static let userInfo = "userInfo"
        //static let idTypes = "idTypes"
    }
    
    @objc dynamic var id = ""
    @objc dynamic var state = ""
    @objc dynamic var name = ""
    @objc dynamic var number = ""
    @objc dynamic var profilePicture = ""
    @objc dynamic var status = ""
    @objc dynamic var permissionLevel = ""
    @objc dynamic var updateTime = "" //Date()
    @objc dynamic var deviceType = ""
    @objc dynamic var linkedUser = ""
    @objc dynamic var userInfo = ""
    
    
    //INVERSE RELATIONSHIP
    let users = LinkingObjects(fromType: User.self, property: "contacts")
    //    @objc dynamic var idTypes = Array<AnyObject>()
    
    //MARK: - Initializer
    convenience init(uuid: String, name: String, number: String, state: String, profilePicture: String) {
        self.init()
        self.id = uuid
        self.name = name
        self.number = number
        self.state = state
        self.profilePicture = profilePicture
    }
    
    /// Init contact object with json data.
    /// -Parameter json: a json object.
    convenience init(with json: JSON) {
        self.init()
        
        print("--------------JSON DATA--------------")
        print(json)
        print("-------------------------------------")
        
        setJsonValues(jsonObject: json)
    }
    
    /// Iterate through nested json data no matter how deep
    /// and set the values
    ///
    /// - Parameter jsonObject: <#jsonObject description#>
    func setJsonValues(jsonObject: JSON) {

        for (key, value):(String, JSON) in jsonObject {
            setJsonValues(jsonObject: value)
            setValue(key: key, val: value)
        }
    }
    
    /// setValue
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - val: <#val description#>
    func setValue(key: String, val: JSON) {
        
        switch (key) {
            case "linked_user":
                id = val.stringValue
                break
            case "permission_level":
                permissionLevel = val.stringValue
                break
            case "update_time":
                updateTime = val.stringValue
                break
            case "user_info":
                userInfo = val.stringValue
                break
            case "device_type":
                deviceType = val.stringValue
                break
            case "idTypes":
                //newContact.
                break
            case "email":
                //newContact.
                break
            case "type":
                //newContact.
                break
            case "publicId":
                id = val.stringValue
                break
            case "username":
                name = val.stringValue
                break
            default:
                return
            }
    }
    
    /// formateDate
    ///
    /// - Parameter dateString: <#dateString description#>
    /// - Returns: <#return value description#>
    public func formateDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: String(describing: dateString))
        return date!
    }
    
    /// encodeImage
    ///
    /// - Parameter uiImage: <#uiImage description#>
    /// - Returns: <#return value description#>
    func encodeImage(uiImage: UIImage) -> String {
        let imageData:NSData = UIImagePNGRepresentation(uiImage)! as NSData
        let dataImage = imageData.base64EncodedString(options: .lineLength64Characters)
        return dataImage
    }
    
    /// decodeImage
    ///
    /// - Parameter stringImage: <#stringImage description#>
    /// - Returns: <#return value description#>
    func decodeImage(stringImage: String) -> UIImage {
        let dataDecode:NSData = NSData(base64Encoded: stringImage, options:.ignoreUnknownCharacters)!
        let image:UIImage = UIImage(data: dataDecode as Data)!
        return image
    }
    
    //MARK: NSCoding
    /// encode
    ///
    /// - Parameter aCoder: <#aCoder description#>
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(state, forKey: PropertyKey.state)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(number, forKey: PropertyKey.number)
        aCoder.encode(profilePicture, forKey: PropertyKey.profilePicture)
        aCoder.encode(status, forKey: PropertyKey.status)
        aCoder.encode(permissionLevel, forKey: PropertyKey.permissionLevel)
        aCoder.encode(updateTime, forKey: PropertyKey.updateTime)
        aCoder.encode(deviceType, forKey: PropertyKey.deviceType)
        aCoder.encode(linkedUser, forKey: PropertyKey.linkedUser)
        aCoder.encode(userInfo, forKey: PropertyKey.userInfo)
    }
    
    //MARK: -
    override static func primaryKey() -> String? {
        return "id"
    }
}

