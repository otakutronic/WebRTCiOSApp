//
//  SocketIOClient.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import SocketIO
import SwiftyJSON

var socket: SocketIOClient!

//MARK: - private

///Check socket status before actual emitting a signal. If it disconnect or nil -> reconnect and emit signal.
///
/// - Parameter socketFunction: <#socketFunction description#>
private func socketConnected(socketFunction: @escaping () -> Swift.Void) {
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { responseString in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                socketFunction()
            }
        }
    } else {
        socketFunction()
    }
}

// MARK: - SocketIO client connect

/// Client connect
///
/// - Parameter completionHandler: <#completionHandler description#>
func socketIO_Connect(completionHandler: @escaping (_ responseString: String) -> ()) {
    
    //socket = SocketIOClient(socketURL: NSURL(string: "http://13.114.161.39:3000")! as URL)
    socket = SocketIOClient(socketURL: NSURL(string: "http://13.230.235.178:3000")! as URL)
    //socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.33.205:3000")! as URL) //Sami's PC

    //    socket.onAny {
    //        print("vvvvvvvvvvvvvvvvvvvvvv")
    //        print("SocketIO event: \"\($0.event)\"")
    //        print("SocketIO event: with items \($0.items!)")
    //        print("^^^^^^^^^^^^^^^^^")
    //    }
    
    // Socket Events
    socket.on(SOCKETIO_EVENT_CONNECT_TAG) {data, ack in
        print("Socket connected")
        completionHandler(SOCKETIO_EVENT_CONNECT_TAG)
    }
    
    if isSocketConnected(socket: socket) == false {
        print("..socket.connect")
        socket.connect()
    }
}

/// Client disconnect
func socketIO_Disconnect() {
    if (socket != nil) && (socket.status == .connected) {
        socket.disconnect()
    }
}

/// isSocketConnected
///
/// - Parameter socket: <#socket description#>
/// - Returns: Boolean true if sockets connected
func isSocketConnected(socket: SocketIOClient) -> (Bool) {
    
    let isConnected:Bool = (socket.status == .notConnected) || (socket.status == .disconnected)
        ? false : true
    
    return isConnected
}

/// initialize
///
/// - Parameters:
///   - uuid: userID description
///   - completionHandler: <#completionHandler description#>
func socketIO_Init(userID: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        print(SOCKETIO_EVENT_INIT_TAG)
        
        socket.emit(SOCKETIO_EVENT_INIT_TAG, userID, PROJECT_KEY)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_INIT_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_INIT_SUCCESS_TAG, data as [AnyObject])
        }
    }
}

/// Password confirm
///
/// - Parameters:
///   - token: <#token description#>
///   - passcode: <#passcode description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_Password_Confirm(token: String, passcode: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_PASSWORD_CONFIRM_TAG, token, "ios", passcode)
        
        socket.off(SOCKETIO_EVENT_PASSWORD_CONFIRM_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_PASSWORD_CONFIRM_FAIL_TAG)

        // Socket Events
        socket.on(SOCKETIO_EVENT_PASSWORD_CONFIRM_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_PASSWORD_CONFIRM_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_PASSWORD_CONFIRM_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_PASSWORD_CONFIRM_FAIL_TAG, data as [AnyObject])
        }
    }
}

/// get users links
///
/// - Parameters:
///   - token: <#token description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_Get_User_Links(token: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_GET_USER_LINKS_TAG, token)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_GET_USER_LINKS_ANSWER_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_USER_LINKS_ANSWER_TAG, data as [AnyObject])
        }
    }
}

/// Gets users full info
///
/// - Parameters:
///   - token: <#token description#>
///   - missingList: <#missingList description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_Get_User_Info(token: String, missingList: Array<Contact>, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        var myJSON = [String]()
        for contact in missingList {
            myJSON.append(contact.number)
        }
        
        socket.emit(SOCKETIO_EVENT_GET_USER_INFO_TAG, token, myJSON)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_GET_USER_INFO_ANSWER_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_USER_INFO_ANSWER_TAG, data as [AnyObject])
        }
    }
}

/// make a remore connection
///
/// - Parameters:
///   - token: <#token description#>
///   - roomID: <#roomID description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_Make_Remote_Connection(completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    
    func makeRemoteConnection() {
        
        socket.off(SOCKETIO_EVENT_CALL_INCOMING_TAG)
        socket.off(SOCKETIO_EVENT_CALL_CANCELLED_TAG)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_CALL_INCOMING_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_INCOMING_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CALL_CANCELLED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_CANCELLED_TAG, data as [AnyObject])
        }
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                makeRemoteConnection()
            }
        }
    } else {
        makeRemoteConnection()
    }
}

/// make a call request
///
/// - Parameters:
///   - token: <#token description#>
///   - linkID: linkID description
///   - callType: callType description
///   - completionHandler: <#completionHandler description#>
func socketIO_Call_Request(token: String, linkID: String, callType: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        
        socket.emit(SOCKETIO_EVENT_CALL_REQUEST_TAG, token, linkID, callType)
        
        socket.off(SOCKETIO_EVENT_CALL_REQUEST_CREATED_TAG)
        socket.off(SOCKETIO_EVENT_CALL_REQUEST_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CALL_REQUEST_FAIL_TAG)
        socket.off(SOCKETIO_EVENT_CALL_ACCEPTED_TAG)
        socket.off(SOCKETIO_EVENT_CALL_REFUSED_TAG)
        socket.off(SOCKETIO_EVENT_NEW_RTC_CONNECTION)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_CALL_REQUEST_CREATED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_REQUEST_CREATED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CALL_REQUEST_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_REQUEST_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CALL_REQUEST_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_REQUEST_FAIL_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CALL_ACCEPTED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_ACCEPTED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CALL_REFUSED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_REFUSED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_NEW_RTC_CONNECTION) {data, ack in
            completionHandler(SOCKETIO_EVENT_NEW_RTC_CONNECTION, data as [AnyObject])
        }
    }
}

/// accept a call request
///
/// - Parameters:
///   - token: <#token description#>
///   - sessionID: sessionID description
///   - completionHandler: <#completionHandler description#>
func socketIO_Call_Accept(token: String, sessionID: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_CALL_ACCEPT_TAG, token, sessionID)
        
        socket.off(SOCKETIO_EVENT_CALL_ACCEPT_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CALL_ACCEPT_FAIL_TAG)
        socket.off(SOCKETIO_EVENT_NEW_RTC_CONNECTION)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_CALL_ACCEPT_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_ACCEPT_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CALL_ACCEPT_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_ACCEPT_FAIL_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_NEW_RTC_CONNECTION) {data, ack in
            completionHandler(SOCKETIO_EVENT_NEW_RTC_CONNECTION, data as [AnyObject])
        }
    }
}

/// refuse calling comebody
///
/// - Parameters:
///   - token: <#token description#>
///   - sessionID: <#sessionID description#>
func socketIO_Call_Refuse(token: String, sessionID: String) -> Void {
    
    func callRefuse() {
        
        socket.emit(SOCKETIO_EVENT_CALL_REFUSE_TAG, token, sessionID)
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                callRefuse()
            }
        }
    } else {
        callRefuse()
    }
}

/// cancel calling comebody
///
/// - Parameters:
///   - token: <#token description#>
///   - sessionID: <#sessionID description#>
func socketIO_Call_Cancel(token: String, sessionID: String) -> Void {
    
    func callCancel() {
        
        socket.emit(SOCKETIO_EVENT_CALL_CANCEL_TAG, token, sessionID)
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                callCancel()
            }
        }
    } else {
        callCancel()
    }
}

/// call request received
///
/// - Parameters:
///   - token:
///   - sessionID: sessionID description
///   - completionHandler: <#completionHandler description#>
func socketIO_Call_Request_Received(token: String, sessionID: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_CALL_CANCEL_TAG, token, sessionID)
    }
}

/// webRTC create or join room
///
/// - Parameters:
///   - token: <#token description#>
///   - roomID: <#roomID description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_CreateOrJoin(token: String, roomID: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    
    func createOrJoin() {
        
        socket.emit(SOCKETIO_EVENT_CREATE_OR_JOIN_TAG, token, roomID)
        
        socket.off(SOCKETIO_EVENT_CREATED_TAG)
        socket.off(SOCKETIO_EVENT_JOINED_TAG)
        socket.off(SOCKETIO_EVENT_FULL_TAG)
        socket.off(SOCKETIO_EVENT_MESSAGE_TAG)
        //socket.off(SOCKETIO_EVENT_LEAVING_TAG)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_CREATED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CREATED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_JOINED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_JOINED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_FULL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_FULL_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_MESSAGE_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_MESSAGE_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_LEAVING_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_LEAVING_TAG, data as [AnyObject])
        }
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                createOrJoin()
            }
        }
    } else {
        createOrJoin()
    }
}

/// webRTC leave room
///
/// - Parameters:
///   - token: <#token description#>
///   - roomID: <#roomID description#>
func socketIO_Leave(token: String, roomID: String) -> Void {
    
    func leave() {
        
        socket.emit(SOCKETIO_EVENT_LEAVE_TAG, token, roomID)
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                leave()
            }
        }
    } else {
        leave()
    }
}

/// rtc message
///
/// - Parameters:
///   - token: <#token description#>
///   - roomID: <#roomID description#>
///   - messageObject: <#messageObject description#>
func socketIO_RTCMessage(token: String, roomID: String, messageObject: JSON) -> Void {
    
    func sentRTCMessage() {
        
        let message = messageObject.rawString()!
        socket.emit(SOCKETIO_EVENT_SEND_MESSAGE_TAG, token, roomID, message)
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                sentRTCMessage()
            }
        }
    } else {
        sentRTCMessage()
    }
}

// MARK: - isUUIDRegisteredMobile
/// <#Description#>
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_IsUUIDRegistered(uuid: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_IS_UUID_REGISTERED_TAG,uuid)
        socket.off(SOCKETIO_EVENT_UUID_REGISTERED_TAG)
        socket.off(SOCKETIO_EVENT_UUID_NOT_REGISTERED_TAG)
        
        socket.on(SOCKETIO_EVENT_UUID_REGISTERED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_UUID_REGISTERED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_UUID_NOT_REGISTERED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_UUID_NOT_REGISTERED_TAG, data as [AnyObject])
        }
    }
}

// MARK: - isNumberRegistered

/// socketIO_IsNumberRegistered
///
/// - Parameters:
///   - number: <#number description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_IsNumberRegistered(number: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    
    socketConnected {
        socket.emit(SOCKETIO_EVENT_IS_NUMBER_REGISTERED_TAG,number)
        socket.off(SOCKETIO_EVENT_NUMBER_REGISTERED_TAG)
        socket.off(SOCKETIO_EVENT_NUMBER_NOT_REGISTERED_TAG)
        
        socket.on(SOCKETIO_EVENT_NUMBER_REGISTERED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_NUMBER_REGISTERED_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_NUMBER_NOT_REGISTERED_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_NUMBER_NOT_REGISTERED_TAG, data as [AnyObject])
        }
    }
}

// MARK: - ChangeUUID

/// socketIO_ChangeUUID
///
/// - Parameters:
///   - phoneNumber: <#phoneNumber description#>
///   - uuid: <#uuid description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_ChangeUUID(phoneNumber: String, uuid: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "number": phoneNumber as AnyObject,
            "newUUID": uuid as AnyObject
        ]
        
        print("changeUUID data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_CHANGE_UUID_TAG,myJSON)
        socket.off(SOCKETIO_EVENT_CHANGE_UUID_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_UUID_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_UUID_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CHANGE_UUID_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CHANGE_UUID_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CHANGE_UUID_FAIL_TAG, data as [AnyObject])
        }
        
    }
}

// MARK: - GetMyData

/// socketIO_GetMyData
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_GetMyData(uuid: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_GET_MYDATA_TAG,uuid)
        socket.off(SOCKETIO_EVENT_GET_MYDATA_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_GET_MYDATA_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_GET_MYDATA_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_MYDATA_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_GET_MYDATA_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_MYDATA_FAIL_TAG, data as [AnyObject])
        }
        
    }
}

// MARK: - GetFullInfo

/// GetFullInfo
///
/// - Parameters:
///   - missingList: <#missingList description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_GetFullInfo(missingList: Array<Contact>, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        var myJSON = [String]()
        for contact in missingList {
            myJSON.append(contact.number)
        }
        
        print("getFullInfo data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_GET_FULL_INFO_TAG,myJSON)
        socket.off(SOCKETIO_EVENT_GET_FULL_INFO_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_GET_FULL_INFO_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_GET_FULL_INFO_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_FULL_INFO_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_GET_FULL_INFO_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_FULL_INFO_FAIL_TAG, data as [AnyObject])
        }
        
    }
}

// MARK: - Get Last App Version

/// socketIO_GetLastAppVersion
///
/// - Parameter completionHandler: <#completionHandler description#>
func socketIO_GetLastAppVersion(completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        socket.emit(SOCKETIO_EVENT_GET_LAST_APP_VERSION_TAG)
        socket.off(SOCKETIO_EVENT_GET_LAST_APP_VERSION_SUCCESS_TAG)
        
        socket.on(SOCKETIO_EVENT_GET_LAST_APP_VERSION_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_GET_LAST_APP_VERSION_SUCCESS_TAG, data as [AnyObject])
        }
        
    }
}

// MARK: - Register
func socketIO_Register(myData: User, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        
        let auth_type_ios: [String: AnyObject] = [
            "auth_type": "ios" as AnyObject,
            "password": myData.password as AnyObject,
            "securityQuestion": myData.secretQuestion as AnyObject,
            "securityAnswer": myData.secretAnswer as AnyObject,
            "apple_id": LibraryAPI.shared.appData.fmcToken as AnyObject,
            "applevoip": LibraryAPI.shared.appData.voipToken as AnyObject
        ]
        
        let auth_type_mail: [String: AnyObject] = [
            "auth_type": "email" as AnyObject,
            "email": myData.email as AnyObject,
            "password": myData.password as AnyObject
        ]
        
        let auth_types = [auth_type_ios, auth_type_mail]
        
        socket.emit(SOCKETIO_EVENT_REGISTER_TAG, myData.name, myData.id, "ios", auth_types, myData.profilePicture)
        
        
        socket.off(SOCKETIO_EVENT_REGISTER_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_REGISTER_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_REGISTER_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_REGISTER_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_REGISTER_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_REGISTER_FAIL_TAG, data as [AnyObject])
        }
        
    }
}

// MARK: - DeleteAccount

/// socketIO_DeleteAccount
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_DeleteAccount(uuid: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "uuid": uuid as AnyObject
        ]
        
        print("DeleteAccount data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_DELETE_ACCOUNT_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_DELETE_ACCOUNT_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_DELETE_ACCOUNT_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_DELETE_ACCOUNT_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_DELETE_ACCOUNT_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_DELETE_ACCOUNT_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_DELETE_ACCOUNT_FAIL_TAG, data as [AnyObject])
        }
        
    }
}

// MARK: - Change Data

/// socketIO_ChangeName
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - name: <#name description#>
///   - success: <#success description#>
///   - failure: <#failure description#>
func socketIO_ChangeName(uuid: String, name: String,
                         success: @escaping (_ responseData: [AnyObject]) -> (),
                         failure: @escaping (_ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "uuid": uuid as AnyObject,
            "userName": name as AnyObject
        ]
        
        print("ChangeName data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_CHANGE_NAME_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_CHANGE_NAME_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_NAME_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_NAME_SUCCESS_TAG) {data, ack in
            success(data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CHANGE_NAME_FAIL_TAG) {data, ack in
            failure(data as [AnyObject])
        }
    }
}

/// socketIO_ChangeEmail
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - email: <#email description#>
///   - success: <#success description#>
///   - failure: <#failure description#>
func socketIO_ChangeEmail(uuid: String, email: String,
                          success: @escaping (_ responseData: [AnyObject]) -> (),
                          failure: @escaping (_ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "uuid": uuid as AnyObject,
            "mailAddress": email as AnyObject
        ]
        
        print("ChangeEmail data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_CHANGE_EMAIL_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_CHANGE_EMAIL_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_EMAIL_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_EMAIL_SUCCESS_TAG) {data, ack in
            success(data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CHANGE_EMAIL_FAIL_TAG) {data, ack in
            failure(data as [AnyObject])
        }
    }
}

/// socketIO_ChangePattern
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - newPattern: <#newPattern description#>
///   - success: <#success description#>
///   - failure: <#failure description#>
func socketIO_ChangePattern(uuid: String, newPattern: String,
                            success: @escaping (_ responseData: [AnyObject]) -> (),
                            failure: @escaping (_ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "uuid": uuid as AnyObject,
            "pattern": newPattern.sha1 as AnyObject
        ]
        
        print("ChangePattern data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_CHANGE_PATTERN_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_CHANGE_PATTERN_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_PATTERN_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_PATTERN_SUCCESS_TAG) {data, ack in
            success(data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CHANGE_PATTERN_FAIL_TAG) {data, ack in
            failure(data as [AnyObject])
        }
        
    }
}

/// socketIO_ChangeSecretQ
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - secretQ: <#secretQ description#>
///   - success: <#success description#>
///   - failure: <#failure description#>
func socketIO_ChangeSecretQ(uuid: String, secretQ: String,
                            success: @escaping (_ responseData: [AnyObject]) -> (),
                            failure: @escaping (_ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "uuid": uuid as AnyObject,
            "question": secretQ as AnyObject
        ]
        
        print("ChangeSecretQ data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_CHANGE_SECRET_Q_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_CHANGE_SECRET_Q_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_SECRET_Q_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_SECRET_Q_SUCCESS_TAG) {data, ack in
            success(data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CHANGE_SECRET_Q_FAIL_TAG) {data, ack in
            failure(data as [AnyObject])
        }
        
    }
}

/// socketIO_ChangeSecretA
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - secretA: <#secretA description#>
///   - success: <#success description#>
///   - failure: <#failure description#>
func socketIO_ChangeSecretA(uuid: String, secretA: String,
                            success: @escaping (_ responseData: [AnyObject]) -> (),
                            failure: @escaping (_ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "uuid": uuid as AnyObject,
            "answer": secretA.sha1 as AnyObject
        ]
        
        print("ChangeSecretA data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_CHANGE_SECRET_A_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_CHANGE_SECRET_A_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_SECRET_A_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_SECRET_A_SUCCESS_TAG) {data, ack in
            success(data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_CHANGE_SECRET_A_FAIL_TAG) {data, ack in
            failure(data as [AnyObject])
        }
        
    }
}

/// socketIO_ChangeProfilePicture
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - base64Picture: <#base64Picture description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_ChangeProfilePicture(uuid: String, base64Picture: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "base64Picture": base64Picture as AnyObject,
            "uuid": uuid as AnyObject
        ]
        socket.off(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_SUCCESS_TAG, data as [AnyObject])
        }
        socket.on(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_FAIL_TAG, data as [AnyObject])
        }
        
        socket.emit(SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_TAG, myJSON)
    }
}

// MARK: - Add QR Code

/// Add QR code
///
/// - Parameters:
///   - token: <#token description#>
///   - qrcode: <#qrcode description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_AddQRCode(token: String, qrcode: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    func addQRCode() {
        
        socket.emit(SOCKETIO_EVENT_REQUEST_QRCODE_TAG, token, qrcode)
        
        socket.off(SOCKETIO_EVENT_REQUEST_QRCODE_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_REQUEST_QRCODE_FAIL_TAG)
        
        // Socket Events
        socket.on(SOCKETIO_EVENT_REQUEST_QRCODE_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_REQUEST_QRCODE_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_REQUEST_QRCODE_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_REQUEST_QRCODE_FAIL_TAG, data as [AnyObject])
        }
    }
    
    if (socket == nil) || (socket.status == .disconnected)  {
        socketIO_Connect() { (responseString) in
            if responseString == SOCKETIO_EVENT_CONNECT_TAG {
                addQRCode()
            }
        }
    } else {
        addQRCode()
    }
}

// MARK: - Add Request

/// socketIO_AddRequest
///
/// - Parameters:
///   - uuid: <#uuid description#>
///   - phoneNumber: <#phoneNumber description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_AddRequest(uuid: String, phoneNumber: String, completionHandler: @escaping (_ responseString: String, _ responseData: [AnyObject]) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "destNumber": phoneNumber as AnyObject,
            "uuid": uuid as AnyObject
        ]
        
        print("AddRequest data:\(myJSON)")
        socket.emit(SOCKETIO_EVENT_ADD_REQUEST_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG)
        
        socket.on(SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG, data as [AnyObject])
        }
        
        socket.on(SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG, data as [AnyObject])
        }
    }
}

// MARK: - Call Contact

/// socketIO_CallContact
///
/// - Parameters:
///   - myData: <#myData description#>
///   - contact: <#contact description#>
///   - completionHandler: <#completionHandler description#>
func socketIO_CallContact(myData: User, contact: Contact, completionHandler: @escaping (_ responseString: String, _ responseData: AnyObject) -> ()) {
    socketConnected {
        let myJSON : [String: AnyObject] = [
            "destName": contact.name as AnyObject,
            "destNumber": contact.number as AnyObject,
            "uuid": myData.id as AnyObject
        ]
        
        print("CallContact data:\(myJSON)")
        
        socket.emit(SOCKETIO_EVENT_CALL_REQUEST_TAG, myJSON)
        socket.off(SOCKETIO_EVENT_CALL_SUCCESS_TAG)
        socket.off(SOCKETIO_EVENT_CALL_FAIL_TAG)
        socket.off(SOCKETIO_EVENT_CALL_START_TAG)
        socket.off(SOCKETIO_EVENT_CALL_BUSY_TAG)
        socket.off(SOCKETIO_EVENT_CALL_REJECT_TAG)
        socket.off(SOCKETIO_EVENT_CALL_CANCEL_TAG)
        
        socket.on(SOCKETIO_EVENT_CALL_SUCCESS_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_SUCCESS_TAG, data as AnyObject)
        }
        
        socket.on(SOCKETIO_EVENT_CALL_FAIL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_FAIL_TAG, data as AnyObject)
        }
        
        socket.on(SOCKETIO_EVENT_CALL_START_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_START_TAG, data as AnyObject)
        }
        
        socket.on(SOCKETIO_EVENT_CALL_BUSY_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_BUSY_TAG, data as AnyObject)
        }
        socket.on(SOCKETIO_EVENT_CALL_REJECT_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_REJECT_TAG, data as AnyObject)
        }
        socket.on(SOCKETIO_EVENT_CALL_CANCEL_TAG) {data, ack in
            completionHandler(SOCKETIO_EVENT_CALL_CANCEL_TAG, data as AnyObject)
        }
        
    }
}
