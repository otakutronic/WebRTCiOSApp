//
//  LibraryAPI.swift
//  AppTapia
//
//  Created by Andy 15/09/17.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON
import WebRTC

/// LibraryAPI facade will be exposed to other code, but should hide complexity from the rest of the app.

final class LibraryAPI {
    
    static let shared = LibraryAPI()
    private let httpClient = HTTPClient()
    private let dataManager = DataManager()
    private var webRTCManager = RTCManager()
    private var qrCodeReader = QRCodeReader()
    
    private init() {
        // initilization code
    }
    
    /// checkExistingUser
    ///
    /// - Returns: Return true if user exists
    func checkExistingUser() -> Bool {
        let userExists:Bool = dataManager.checkExistingUser()
        return userExists
    }
    
    /// initialize
    ///
    /// - Parameters:
    ///   - success: return response string & data on success
    ///   - failure: return errorMessage & data on failure
    func initialize(success: @escaping (_ responseData: [AnyObject]) -> (),
                    failure: @escaping (_ errorMessage: String, _ responseData: [AnyObject]) -> ()) {
        
        let userId = DataManager.currentUser.id
        
        print("userId:\(userId)")
        
        socketIO_Init(userID: userId) { (responseString, responseData) in
            print("@@@@@ socketIO_Init:\(responseString)")
            
            if (responseString == SOCKETIO_EVENT_INIT_SUCCESS_TAG) {
                print("init answer##########: \(responseData)")
                if let isRegistered: Bool = responseData.first as? Bool {
                    self.dataManager.setAppToken(dataObject: responseData)
                    
                    if isRegistered {
                        success(responseData)
                    } else {
                        failure(responseString, responseData)
                    }
                    
                }
                
                self.dataManager.setAppToken(dataObject: responseData)
                success(responseData)
            } else {
                failure(responseString, responseData)
            }
        }
    }
    
    /// login
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - passcode: <#passcode description#>
    ///   - completion: return response string & data on completion
    func login(token: String, passcode: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        print("try login")
        socketIO_Password_Confirm(token: token, passcode: passcode) { (responseString, responseData) in
            print("@@@@@ socketIO_Password_Confirm:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// setUserContacts
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - completion: <#completion description#>
    func setUserContacts(token: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        
        socketIO_Get_User_Links(token: token) { (responseString, responseData) in
            print("@@@@@ socketIO_Get_User_Links:\(responseString)")
            
            // update data to model
            self.dataManager.contactsManager.setList(dataObject: responseData)
            
            // return data on completion
            completion(responseString, responseData)
        }
    }

    /// setUserContactsFull
    ///
    /// - Parameters:
    ///   - missingList: <#missingList description#>
    ///   - completion: <#completion description#>
    func setUserContactsFull(missingList: Array<Contact>, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_GetFullInfo(missingList: missingList) { (responseString, responseData) in
            print("@@@@@ socketIO_GetFullInfo:\(responseString)")
            
            // update data to model
            //self.dataManager.contactsManager.setList(dataObject: responseData)
            
            // return data on completion
            completion(responseString, responseData)
        }
    }
    
    // socketIO_Get_User_Links
    
    /// getUserContactDataInfo
    ///
    /// - Parameters:
    ///   - <#ID description#>ID:
    ///   - completion: return response string & data on completion
    func getUserContactDataInfo(ID: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_GetMyData(uuid: ID) { (responseString, responseData) in
            print("@@@@@ socketIO_GetMyData:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// createRemoteConnection
    ///
    /// - Parameters:
    ///   - completion: <#completion description#>
    func createRemoteConnection(completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_Make_Remote_Connection() { (responseString, responseData) in
            print("@@@@@ socketIO_Make_Remote_Connection:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// makeCallRequest
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - linkID: <#linkID description#>
    ///   - callType: <#callType description#>
    ///   - completion: <#completion description#>
    func makeCallRequest(token: String, linkID: String, callType: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_Call_Request(token: token, linkID: linkID, callType: callType) { (responseString, responseData) in
            print("@@@@@ socketIO_Call_Request:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// acceptCallRequest
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - sessionID: sessionID description
    ///   - completion: <#completion description#>
    func acceptCallRequest(token: String, sessionID: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_Call_Accept(token: token, sessionID: sessionID) { (responseString, responseData) in
            print("@@@@@ socketIO_Call_Accept:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// refuseCallRequest
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - sessionID: sessionID description
    func refuseCallRequest(token: String, sessionID: String) -> Void {
        print("@@@@@ socketIO_Call_Refuse")
        socketIO_Call_Refuse(token: token, sessionID: sessionID)
    }
    
    /// cancelCallRequest
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - sessionID: <#sessionID description#>
    func cancelCallRequest(token: String, sessionID: String) -> Void {
        print("@@@@@ socketIO_Call_Cancel")
        socketIO_Call_Cancel(token: token, sessionID: sessionID)
    }
    
    /// callRequestReceived
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - sessionID: sessionID description
    ///   - completion: <#completion description#>
    func callRequestReceived(token: String, sessionID: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_Call_Request_Received(token: token, sessionID: sessionID) { (responseString, responseData) in
            print("@@@@@ socketIO_Call_Request_Received:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// startCall
    ///
    /// - Parameter contact: <#contact description#>
    func startCall(contact: Contact) -> Void {
        
        print("set web rtc call stuff here")
        
    }
    
    /// WebRTC Start
    ///
    /// - Parameter view: <#view description#>
    func startRTC(view: UIViewController, completion: @escaping (_ responseString: String) -> Void) {
        rtcManager.delegate = view as? RTCManagerDelegate
        rtcManager.startConnection()
        completion("complete")
    }
    
    /// WebRTC Stop
    func stopRTC() -> Void {
        rtcManager.disconnect()
    }
    
    /// WebRTC make offer
    func makeOfferRTC() -> Void {
        rtcManager.makeOffer()
    }
    
    /// WebRTC Answer Offer
    func answerOfferRTC(sdpDescription: String) -> Void {
        rtcManager.createAnswerForOfferReceived(withRemoteSDP: sdpDescription)
    }
    
    /// WebRTC Answer Received
    func answerReceivedRTC(sdpDescription: String) -> Void {
        rtcManager.handleAnswerReceived(withRemoteSDP: sdpDescription)
    }
    
    /// WebRTC add Ice Candidate
    func addIceRTC(sdp: String, sdpMLineIndex: Int32, sdpMid: String) -> Void {
        rtcManager.addIceCandidate(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
    }
    
    /// Saves the chat session to the DB
    func saveVideoSession(id: String, contactID: String, date: String, state: String, length: String) -> Void {
        dataManager.updateHistoryList(id: id, contactID: contactID, date: date, state: state, length: length)
    }
    
    /// gets the saved chat history
    func getVideoHistory(id: String) -> Results<VideoHistory> {
        return dataManager.videoHistoryManager.getVideoChatHistoryList(id: id)
    }
    
    /// QR code reader Start
    ///
    /// - Parameter view: <#view description#>
    func startQRCodeReader(view: UIView, viewController: UIViewController, completion: @escaping (_ responseString: String) -> Void) {
        qrCodeReader.delegate = viewController as? QRCodeReaderDelegate
        let setupResult:String = qrCodeReader.initReader(view: view)
        print("@@@@@ startQRCodeReader result: \(setupResult)")
        completion(setupResult)
    }
    
    /// restarts QR code reader
    func restartQRCodeReader() -> Void {
        qrCodeReader.start()
    }
    
    /// checkUsersData
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - completion: return response string & data on completion
    func checkUsersData(ID: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_IsUUIDRegistered(uuid: ID) { (responseString, responseData) in
            print("@@@@@ socketIO_IsUUIDRegistered:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// createOrJoinRoom
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - roomID: roomID description
    ///   - completion: return response string & data on completion
    func createOrJoinRoom(token: String, roomID: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_CreateOrJoin(token: token, roomID: roomID) { (responseString, responseData) in
            print("@@@@@ socketIO_CreateOrJoin:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// RTCMessage
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - roomID: <#roomID description#>
    ///   - messageObject: <#messageObject description#>
    func RTCMessage(token: String, roomID: String, messageObject: JSON) -> Void {
        socketIO_RTCMessage(token: token, roomID: roomID, messageObject: messageObject)
        print("@@@@@ socketIO_RTCMessage")
    }
    
    /// leaveRoom
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - roomID: roomID description
    func leaveRoom(token: String, roomID: String) -> Void {
        socketIO_Leave(token: token, roomID: roomID)
        print("@@@@@ socketIO_Leave")
    }
    
    /// isNumberRegistered
    ///
    /// - Parameters:
    ///   - phoneNumber: phoneNumber description
    ///   - completion: return response string & data on completion
    func isNumberRegistered(phoneNumber: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_IsNumberRegistered(number: phoneNumber) { (responseString, responseData) in
            print("@@@@@ socketIO_IsNumberRegistered:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// changeUserID
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - phoneNumber: phoneNumber description
    ///   - completion: return response string & data on completion
    func changeUserID(ID: String, phoneNumber: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_ChangeUUID(phoneNumber: phoneNumber, uuid: ID) { (responseString, responseData) in
            print("@@@@@ socketIO_ChangeUUID:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// register
    ///
    /// - Parameters:
    ///   - object: an User object
    ///   - success: return data on success
    ///   - failure: return error on failure
    func register(newUser: User,
                  success: @escaping (_ responseData: [AnyObject]) -> Void,
                  failure: @escaping (_ responseData: [AnyObject]) -> Void) {
        socketIO_Register(myData: newUser) { (responseString, responseData) in
            print("@@@@@ socketIORegister:\(responseString)")
            
            if (responseString == SOCKETIO_EVENT_REGISTER_SUCCESS_TAG) {
                success(responseData)
            } else {
                failure(responseData)
            }
        }
    }
    
    /// changeName
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - NewUsername: new username description
    ///   - success: return response string & data on completion
    ///   - failure: return error message on completion
    func changeName(ID: String, newUsername: String,
                    success: @escaping (_ responseData: [AnyObject]) -> (),
                    failure: @escaping (_ responseData: [AnyObject]) -> ()) {

        socketIO_ChangeName(uuid: ID, name: newUsername, success: { (responseData) in
            try! self.dataManager.realm.write {
                DataManager.currentUser.name = newUsername
                success(responseData)
            }
        }, failure: { (responseData) in
            failure(responseData)
        })
        
    }
    
    /// changeMail
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - emilAddress: emilAddress description
    ///   - success: return response string & data on completion
    ///   - failure: return error message on completion
    func changeMail(ID: String, emilAddress: String,
                    success: @escaping (_ responseData: [AnyObject]) -> (),
                    failure: @escaping (_ responseData: [AnyObject]) -> ()) {
        
        socketIO_ChangeEmail(uuid: ID, email: emilAddress, success: { (responseData) in
            try! self.dataManager.realm.write {
                DataManager.currentUser.email = emilAddress
                success(responseData)
            }
            success(responseData)
        }, failure: { (responseData) in
            failure(responseData)
        })
    }
    
    /// changeSecretQ
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - emilAddress: emilAddress description
    ///   - success: return response string & data on completion
    ///   - failure: return error message on completion
    func changeSecretQ(ID: String, question: String,
                       success: @escaping (_ responseData: [AnyObject]) -> (),
                       failure: @escaping (_ responseData: [AnyObject]) -> ()) {
        socketIO_ChangeSecretQ(uuid: ID, secretQ: question, success: { (responseData) in
            success(responseData)
        }, failure: { (responseData) in
            failure(responseData)
        })
    }
    
    /// changeSecretA
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - emilAddress: emilAddress description
    ///   - success: return response string & data on completion
    ///   - failure: return error message on completion
    func changeSecretA(ID: String, answer: String,
                       success: @escaping (_ responseData: [AnyObject]) -> (),
                       failure: @escaping (_ responseData: [AnyObject]) -> ()) {
        socketIO_ChangeSecretA(uuid: ID, secretA: answer, success: { (responseData) in
            success(responseData)
        }, failure: { (responseData) in
            failure(responseData)
        })
    }
    
    /// changeProfilePicture
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - base64Picture: base64string image
    ///   - completion: return response string & data on completion
    func changeProfilePicture(ID: String, base64Picture: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_ChangeProfilePicture(uuid: ID, base64Picture: base64Picture, completionHandler:  { (responseString, responseData) in
            print("@@@@@ socketIO_CallContact:\(responseString)")
            completion(responseString, responseData)
        })
    }
    
    /// callContact
    ///
    /// - Parameters:
    ///   - object: <#object description#>
    ///   - contact: <#contact description#>
    ///   - completion: return response string & data on completion
    func callContact(object: User, contact: Contact, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_CallContact(myData: object, contact: contact) { (responseString, responseData) in
            print("@@@@@ socketIO_CallContact:\(responseString)")
            completion(responseString, responseData as! [AnyObject])
        }
    }
    
    /// changePassword
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - password: <#password description#>
    ///   - success: return response string & data on completion
    ///   - failure: return error message on completion
    func changePassword(ID: String, password: String,
                        success: @escaping (_ responseData: [AnyObject]) -> (),
                        failure: @escaping (_ responseData: [AnyObject]) -> ()) {
        socketIO_ChangePattern(uuid: ID, newPattern: password, success: { (responseData) in
            success(responseData)
        }, failure: { (responseData) in
            failure(responseData)
        })
    }
    
    // add QR code
    ///
    /// - Parameters:
    ///   - token: <#token description#>
    ///   - qrcode: <#qrcode description#>
    ///   - completion: <#completion description#>
    func addQRCode(token: String, qrcode: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        print("AddQRCode")
        socketIO_AddQRCode(token: token, qrcode: qrcode) { (responseString, responseData) in
            print("@@@@@ socketIO_AddQRCode:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
    /// add phone number request
    ///
    /// - Parameters:
    ///   - uuid: <#uuid description#>
    ///   - phoneNumber: <#phoneNumber description#>
    ///   - completion: <#completion description#>
    func addPhoneNumberRequest(uuid: String, phoneNumber: String, completion: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> Void) {
        socketIO_AddRequest(uuid: uuid, phoneNumber: phoneNumber) { (responseString, responseData) in
            print("@@@@@ socketIO_AddRequest:\(responseString)")
            completion(responseString, responseData)
        }
    }
    
//    /// downloadImageTest
//    ///
//    /// - Parameters:
//    ///   - completion: return response on completion
//    func downloadImageTest(completion: @escaping (_ result: String) -> Void) {
//
//        let image1 = httpClient.downloadImage("https://static.pexels.com/photos/70497/pexels-photo-70497.jpeg")
//        let image2 = httpClient.downloadImage("https://static.pexels.com/photos/46239/salmon-dish-food-meal-46239.jpeg")
//        let image3 = httpClient.downloadImage("https://static1.squarespace.com/static/554b9b24e4b0bc56dd1c4619/555fd476e4b0b17b145cdca9/556c94f4e4b013ebb5a9097f/1433179382174/IMG_4354.jpeg")
//        let image4 = httpClient.downloadImage("https://thumbs.dreamstime.com/z/fast-food-2458108.jpg")
//        let image5 = httpClient.downloadImage("https://static.kidspot.com.au/cm_assets/527/healthy-party-food-main-image_690-20150330000315.jpg~q75,dx720y432u1r1gg,c--.jpg")
//
//        // return response on completion
//        if (image1 != nil && image2 != nil && image3 != nil && image4 != nil && image5 != nil) {
//            completion("download success")
//        } else {
//            completion("download fail")
//        }
//    }
    
    /// rtcManager
    public var rtcManager: RTCManager {
        get {
            return webRTCManager
        }
        set {
            webRTCManager = newValue
        }
    }
    
    /// qrCodeMReader
    public var codeReader: QRCodeReader {
        get {
            return qrCodeReader
        }
        set {
            qrCodeReader = newValue
        }
    }
    
    /// get and set users data
//    public var userData: User {
//        get {
//            return dataManager.userData
//        }
//        set {
//            dataManager.userData = newValue
//        }
//    }
    
    /// get and set apps data
    public var appData: AppData {
        get {
            return dataManager.appsData
        }
        set {
            dataManager.appsData = newValue
        }
    }
    
    /// setUserData
    ///
    /// - Parameter object: <#object description#>
    func setUserData( object: User) {
        dataManager.setUserData(userObject: object)
    }
    
    /// setContactData
    ///
    /// - Parameter newContact:
    func setContactData(newContact: Contact) {
        dataManager.updateContactsList(newContact: newContact)
    }
    
    /// setUserData
    ///
    /// - Parameters:
    ///   - field: <#field description#>
    ///   - val: <#val description#>
//    func setUserData(field: String, val: String) {
//        dataManager.setUserData(field: field, val: val)
//    }
    
    /// saveUserData
    func saveUserData() {
        dataManager.saveUserDataLocal()
    }
    
    /// getVideoChatList
    ///
    /// - Returns: users video chatentries
    func getVideoChatList() -> Results<Contact> {
        return dataManager.contactsManager.getVideoChatList()
    }
    
    /// getAlbumList
    ///
    /// - Returns: users album entries
    func getAlbumList() -> Results<Contact> {
        return dataManager.contactsManager.getAlbumList()
    }
    
    /// getLinksList
    ///
    /// - Returns: users monitor entries
    func getLinksList() -> Results<Contact> {
        return dataManager.contactsManager.getLinksList()
    }
    
    /// getMonitorList
    ///
    /// - Returns: users monitor entries
    func getMonitorList() -> Results<Contact> {
        return dataManager.contactsManager.getMonitorList()
    }
    
    /// getSettingsList
    ///
    /// - Returns: settings list
    func getSettingsList() -> Results<Setting> {
        return dataManager.settingsManager.getSettingList()
    }
}

