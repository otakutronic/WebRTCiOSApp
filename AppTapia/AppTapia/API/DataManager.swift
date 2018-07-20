//
//  DataManager.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import UIKit
import SwiftyJSON
import PhoneNumberKit
import RealmSwift

final class DataManager {
    
    private var appData:AppData
    private var loginSuccess:Bool
    private var phoneNumberKit = PhoneNumberKit()
    let realm = try! Realm()
    static var currentUser:User = User()
    
    // data lists
    private let contactsListManager: ContactsListManager
    private let videoHistoryListManager: VideoHistoryListManager
    private let settingsListManager: SettingsListManager

    /// initialize data
    init() {
        loginSuccess = false

        appData = AppData()
        
        contactsListManager = ContactsListManager(realm: realm)
        videoHistoryListManager = VideoHistoryListManager(realm: realm)
        settingsListManager = SettingsListManager(realm: realm)
        
        if checkExistingUser() {
            DataManager.currentUser = realm.objects(User.self).first!
        } else {
            DataManager.currentUser = User(uuid: UIDevice.current.identifierForVendor!.uuidString) //Just create, do not save yet.
            print("PRIVATEKEY#######: \(DataManager.currentUser.id))")
        }
    }

    /// checkExistingUser
    ///
    /// - Returns: Return true if user exists
    func checkExistingUser() -> Bool {
        let users = realm.objects(User.self)
        return !users.isEmpty
    }
    
    /// setUserData
    ///
    /// - Parameter userObject: userObject description
    func setUserData(userObject: User) {
        
        if(userObject.name != "") {
           DataManager.currentUser.name = userObject.name
        }
        if(userObject.phoneNumber != "") {
            DataManager.currentUser.phoneNumber = userObject.phoneNumber
        }
        if(userObject.email != "") {
            DataManager.currentUser.email = userObject.email
        }
        if(userObject.secretQuestion != "") {
            DataManager.currentUser.secretQuestion = userObject.secretQuestion
        }
        if(userObject.secretAnswer != "") {
            DataManager.currentUser.secretAnswer = userObject.secretAnswer
        }
        if(userObject.password != "") {
            DataManager.currentUser.password = userObject.password
        }
        if(userObject.profilePicture != "") {
            DataManager.currentUser.profilePicture = userObject.profilePicture
        }
    }
    
    /// get and set users data
//    public var userData: User {
//        get {
//            return currentUser
//        }
//        set {
//            currentUser = newValue
//        }
//    }
    
    /// get and set apps data
    public var appsData: AppData {
        get {
            return appData
        }
        set {
            appData = newValue
        }
    }
    
    /// get users list of contacts
    public var contactsManager: ContactsListManager {
        get {
            return contactsListManager
        }
    }
    
    /// get users chat history
    public var videoHistoryManager: VideoHistoryListManager {
        get {
            return videoHistoryListManager
        }
    }
    
    /// get settings data
    public var settingsManager: SettingsListManager {
        get {
            return settingsListManager
        }
    }
    
    // update users chat history
    ///
    /// - Parameter entry: <#entry description#>
    func updateHistoryList(id: String, contactID: String, date: String, state: String, length: String) {
        let videoHistory = VideoHistory(id: id, contactID: contactID, date: date, state: state, length: length)
        videoHistoryListManager.addOrUpdateEntry(entry: videoHistory)
    }
    
    // update user contact
    ///
    /// - Parameter newContact: <#newContact description#>
    func updateContactsList(newContact: Contact) {
        contactsListManager.addOrUpdateEntry(entry: newContact)
    }

    /// set app session token
    ///
    /// - Parameter dataObject: <#dataObject description#>
    func setAppToken(dataObject: [AnyObject]) {
        
        let isRegistered:Bool = JSON(dataObject)[0].boolValue
        print("isRegistered: \(isRegistered)")
            
        if(isRegistered) {
            let token:String = JSON(dataObject)[1].stringValue
            print("setting sessionToken: \(token)")
            appData.sessionToken = token
        }
    }
    
    /// saveUserDataLocal
    func saveUserDataLocal() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(DataManager.currentUser, update: true)
        }
    }
    
    /// formatPhoneNumber
    ///
    /// - Parameter number: <#number description#>
    /// - Returns: <#return value description#>
    func formatPhoneNumber(number: String) -> String {
        var formattedNum: String = ""
        do {
            let phoneNumber = try phoneNumberKit.parse(number, withRegion: "JP")
            formattedNum = phoneNumberKit.format(phoneNumber, toType: .international, withPrefix: true)
            print("Saved formattedNumber:\(formattedNum)")
        }
        catch {
            print("illegal phone number error occured \(error)")
        }
        return formattedNum
    }
}
