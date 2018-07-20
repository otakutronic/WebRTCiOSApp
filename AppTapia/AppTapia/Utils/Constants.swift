//
//  Constants.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import UIKit

//MARK: - Colors

let COLOR_MAIN = UIColorFromRGB(rgbValue: 0xC3D94EFF)
let COLOR_BACKGROUND = UIColorFromRGB(rgbValue: 0xF5F5F5FF)
let COLOR_GREY_A50 = UIColorFromRGB(rgbValue: 0xffffff80)
let COLOR_BLACK = UIColorFromRGB(rgbValue: 0x00000000)

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red:   CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
        green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
        blue:  CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
        alpha: CGFloat(rgbValue  & 0x000000FF) / 255.0
    )
}

//MARK: -

public let PROJECT_KEY : String = "ecbbdb7e-52f7-4c3f-af93-56a1b40a0f2b"
public let WEBRTC_STUN_URL = "stun:stun.l.google.com:19302"
public let WEBRTC_TURN_URL = "turn:192.158.29.39:3478?transport=udp"
public let WEBRTC_TURN_USERNAME = "JZEOEt2V3Qb0y27GRntt2u2PAYA="
public let WEBRTC_TURN_PASSWORD = "28224511:1379330808"

public let SMALL_PICTURE_FOLDER_TAPIA =      FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path+"/smallpicture/tapia/"
public let SMALL_PICTURE_FOLDER_MONITORING = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path+"/smallpicture/monitoring/"

public let PICTURE_FOLDER_TAPIA =            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path+"/bigpicture/tapia/"
public let PICTURE_FOLDER_MONITORING =       FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path+"/bigpicture/monitoring/"


public let WONDERBOX_BROADCAST_PORT = UInt16(8003)
public let WONDERBOX_MANAGE_PORT = UInt16(8001)
public let ENCRYPT_KEY = "TAPIA_THHU";
public let LOGIN_URL = "cars.cyberhood.net"
public let TUNNEL_SERVER_HOSTNAME = "http://homecloud.cyberhood.net"
public let CALL_RPC_LOOP_MAX_COUNT = 3
public let CONTROLLER_ID_CONVERT_NUM = 103056

//UserInfo
public let USER_DEFAULT_IS_FIRST_TAG : String = "UserDefaultIsFirst"
public let USER_DEFAULT_PHONE_NUMBER_TAG : String = "UserDefaultPhoneNumber"
public let USER_DEFAULT_UUID_TAG : String = "UserDefaultUUID"
public let USER_DEFAULT_EMAIL_TAG : String = "UserDefaultEmail"
public let USER_DEFAULT_USERNAME_TAG : String = "UserDefaultUsername"
public let USER_DEFAULT_SECRET_QUESTION_TAG : String = "UserDefaultSecretQuestion"
public let USER_DEFAULT_SECRET_ANSWER_TAG : String = "UserDefaultSecretAnswer"
public let USER_DEFAULT_BASE_64_PROFILE_PICTURE_TAG : String = "UserDefaultBase64ProfilePicture"

//SocketIO event tag
public let SOCKETIO_EVENT_INIT_TAG : String = "init"
public let SOCKETIO_EVENT_INIT_SUCCESS_TAG : String = "init_answer"

public let SOCKETIO_EVENT_PASSWORD_CONFIRM_TAG : String = "password_confirm"
public let SOCKETIO_EVENT_PASSWORD_CONFIRM_SUCCESS_TAG : String = "password_confirmed"
public let SOCKETIO_EVENT_PASSWORD_CONFIRM_FAIL_TAG : String = "password_denied"

public let SOCKETIO_EVENT_GET_USER_LINKS_TAG : String = "get_user_links"
public let SOCKETIO_EVENT_GET_USER_LINKS_ANSWER_TAG : String = "get_user_links_answer"

public let SOCKETIO_EVENT_GET_USER_INFO_TAG : String = "get_users_info"
public let SOCKETIO_EVENT_GET_USER_INFO_ANSWER_TAG : String = "get_users_info_answer"

public let SOCKETIO_EVENT_CALL_REQUEST_TAG : String = "call_request"
public let SOCKETIO_EVENT_CALL_REQUEST_CREATED_TAG : String = "call_request_created"
public let SOCKETIO_EVENT_CALL_REQUEST_SUCCESS_TAG : String = "call_request_success"
public let SOCKETIO_EVENT_CALL_REQUEST_FAIL_TAG : String = "call_request_error"
public let SOCKETIO_EVENT_CALL_INCOMING_TAG : String = "call_incoming" // on remote

public let SOCKETIO_EVENT_CALL_ACCEPT_TAG : String = "call_accept"
public let SOCKETIO_EVENT_CALL_ACCEPT_SUCCESS_TAG : String = "call_accept_success"
public let SOCKETIO_EVENT_CALL_ACCEPT_FAIL_TAG : String = "call_accept_error"
public let SOCKETIO_EVENT_CALL_ACCEPTED_TAG : String = "call_accepted" // on remote

public let SOCKETIO_EVENT_CALL_REFUSE_TAG : String = "call_refuse"
public let SOCKETIO_EVENT_CALL_REFUSED_TAG : String = "call_refused" // on remote

public let SOCKETIO_EVENT_CALL_CANCEL_TAG : String = "call_cancel"
public let SOCKETIO_EVENT_CALL_CANCELLED_TAG : String = "call_cancelled" // on remote

public let SOCKETIO_EVENT_CALL_REQUEST_RECEIVED_TAG : String = "call_request_received"
public let SOCKETIO_EVENT_CALL_REQUEST_RECEIVED_SUCCESS_TAG : String = "call_request_success " // on remote (user received the request)

public let SOCKETIO_EVENT_NEW_RTC_CONNECTION : String = "new_rtc_connection" // on remote and local

public let SOCKETIO_EVENT_REQUEST_QRCODE_TAG : String = "request_qrlink"
public let SOCKETIO_EVENT_REQUEST_QRCODE_SUCCESS_TAG : String = "request_qrlink_success"
public let SOCKETIO_EVENT_REQUEST_QRCODE_FAIL_TAG : String = "request_qrlink_error"





public let SOCKETIO_EVENT_CONNECT_TAG : String = "connect"
public let SOCKETIO_EVENT_ERROR_TAG : String = "SocketIoError"

public let SOCKETIO_EVENT_IS_UUID_REGISTERED_TAG : String = "isUUIDRegisteredMobile"
public let SOCKETIO_EVENT_UUID_REGISTERED_TAG : String = "uuidRegistered"
public let SOCKETIO_EVENT_UUID_NOT_REGISTERED_TAG : String = "uuidNotRegistered"

public let SOCKETIO_EVENT_IS_NUMBER_REGISTERED_TAG : String = "isNumberRegisteredMobile"
public let SOCKETIO_EVENT_NUMBER_REGISTERED_TAG : String = "numberRegistered"
public let SOCKETIO_EVENT_NUMBER_NOT_REGISTERED_TAG : String = "numberNotRegistered"

public let SOCKETIO_EVENT_APP_LOGIN_TAG : String = "appLogin"
public let SOCKETIO_EVENT_APP_LOGIN_SUCCESS_TAG : String = "appLoginSuccess"
public let SOCKETIO_EVENT_APP_LOGIN_FAIL_TAG : String = "appLoginFailure"

public let SOCKETIO_EVENT_CHANGE_UUID_TAG : String = "changeUUIDMobile"
public let SOCKETIO_EVENT_CHANGE_UUID_SUCCESS_TAG : String = "changeSuccess"
public let SOCKETIO_EVENT_CHANGE_UUID_FAIL_TAG : String = "changeFail"

public let SOCKETIO_EVENT_GET_MYDATA_TAG : String = "getMyDataMobile"
public let SOCKETIO_EVENT_GET_MYDATA_SUCCESS_TAG : String = "getMyDataSuccess"
public let SOCKETIO_EVENT_GET_MYDATA_FAIL_TAG : String = "getMyDataFail"

public let SOCKETIO_EVENT_GET_FULL_INFO_TAG : String = "getFullInfoMobile"
public let SOCKETIO_EVENT_GET_FULL_INFO_SUCCESS_TAG : String = "getFullInfoSuccess"
public let SOCKETIO_EVENT_GET_FULL_INFO_FAIL_TAG : String = "getFullInfoFail"

public let SOCKETIO_EVENT_GET_LAST_APP_VERSION_TAG : String = "getLastAppVersion"
public let SOCKETIO_EVENT_GET_LAST_APP_VERSION_SUCCESS_TAG : String = "lastAppVersion"
//public let SOCKETIO_EVENT_GET_LAST_APP_VERSION_FAIL_TAG : String = "getFullInfoFail"

public let SOCKETIO_EVENT_REGISTER_TAG : String = "register"
public let SOCKETIO_EVENT_REGISTER_SUCCESS_TAG : String = "register_success"
public let SOCKETIO_EVENT_REGISTER_FAIL_TAG : String = "register_error"

public let SOCKETIO_EVENT_DELETE_ACCOUNT_TAG : String = "deleteAccountMobile"
public let SOCKETIO_EVENT_DELETE_ACCOUNT_SUCCESS_TAG : String = "deleteSuccess"
public let SOCKETIO_EVENT_DELETE_ACCOUNT_FAIL_TAG : String = "deleteFail"

public let SOCKETIO_EVENT_RESET_PASSWORD_TAG : String = "resetPasswordRequest"
public let SOCKETIO_EVENT_RESET_PASSWORD_SUCCESS_TAG : String = "resetPasswordRequestSuccess"
public let SOCKETIO_EVENT_RESET_PASSWORD_FAIL_TAG : String = "resetPasswordRequestFailure"

public let SOCKETIO_EVENT_NEW_PASSWORD_TAG : String = "newPasswordRequest"
public let SOCKETIO_EVENT_NEW_PASSWORD_SUCCESS_TAG : String = "newPasswordRequestSuccess"
public let SOCKETIO_EVENT_NEW_PASSWORD_FAIL_TAG : String = "newPasswordRequestFailure"

public let SOCKETIO_EVENT_CHANGE_NAME_TAG : String = "change_username"
public let SOCKETIO_EVENT_CHANGE_NAME_SUCCESS_TAG : String = "change_username_success"
public let SOCKETIO_EVENT_CHANGE_NAME_FAIL_TAG : String = "change_username_fail"

public let SOCKETIO_EVENT_CHANGE_EMAIL_TAG : String = "changeMailAddress"
public let SOCKETIO_EVENT_CHANGE_EMAIL_SUCCESS_TAG : String = "changeMailAddressSuccess"
public let SOCKETIO_EVENT_CHANGE_EMAIL_FAIL_TAG : String = "changeMailAddressFail"

public let SOCKETIO_EVENT_CHANGE_PATTERN_TAG : String = "changePattern"
public let SOCKETIO_EVENT_CHANGE_PATTERN_SUCCESS_TAG : String = "changePatternSuccess"
public let SOCKETIO_EVENT_CHANGE_PATTERN_FAIL_TAG : String = "changePatternFail"

public let SOCKETIO_EVENT_CHANGE_SECRET_Q_TAG : String = "changeSecretQuestion"
public let SOCKETIO_EVENT_CHANGE_SECRET_Q_SUCCESS_TAG : String = "changeSecretQuestionSuccess"
public let SOCKETIO_EVENT_CHANGE_SECRET_Q_FAIL_TAG : String = "changeSecretQuestionFail"

public let SOCKETIO_EVENT_CHANGE_SECRET_A_TAG : String = "changeAnswer"
public let SOCKETIO_EVENT_CHANGE_SECRET_A_SUCCESS_TAG : String = "changeAnswerSuccess"
public let SOCKETIO_EVENT_CHANGE_SECRET_A_FAIL_TAG : String = "changeAnswerFail"

public let SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_TAG : String = "changeProfilePicture"
public let SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_SUCCESS_TAG : String = "changeProfilePictureSuccess"
public let SOCKETIO_EVENT_CHANGE_PROFILE_PICTURE_FAIL_TAG : String = "changeProfilePictureFail"

public let SOCKETIO_EVENT_ADD_QRCODE_TAG : String = "addQRRequestMobile"
public let SOCKETIO_EVENT_ADD_QRCODE_SUCCESS_TAG : String = "addQRRequestSuccess"
public let SOCKETIO_EVENT_ADD_QRCODE_FAIL_TAG : String = "addQRRequestFail"

public let SOCKETIO_EVENT_ADD_REQUEST_TAG : String = "addRequestMobile"
public let SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG : String = "addRequestSuccess"
public let SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG : String = "addRequestFail"

public let SOCKETIO_EVENT_CANCEL_ADD_REQUEST_TAG : String = "cancelRequestMobile"
public let SOCKETIO_EVENT_CANCEL_ADD_REQUEST_SUCCESS_TAG : String = "cancelAddRequestSuccess"
public let SOCKETIO_EVENT_CANCEL_ADD_REQUEST_FAIL_TAG : String = "cancelAddRequestFail"

public let SOCKETIO_EVENT_REJECT_REQUEST_TAG : String = "rejectRequestMobile"
public let SOCKETIO_EVENT_REJECT_REQUEST_SUCCESS_TAG : String = "refuseAddRequestSuccess"
public let SOCKETIO_EVENT_REJECT_REQUEST_FAIL_TAG : String = "refuseAddRequestFail"

//public let SOCKETIO_EVENT_CALL_REQUEST_TAG : String = "callRequestMobile"
public let SOCKETIO_EVENT_CALL_SUCCESS_TAG : String = "callSuccess"
public let SOCKETIO_EVENT_CALL_FAIL_TAG : String = "callFail"
public let SOCKETIO_EVENT_CALL_START_TAG : String = "callStart"
public let SOCKETIO_EVENT_CALL_BUSY_TAG : String = "callBusy"
public let SOCKETIO_EVENT_CALL_REJECT_TAG : String = "callReject"
//public let SOCKETIO_EVENT_CALL_CANCEL_TAG : String = "callCancel"

public let SOCKETIO_EVENT_CANCEL_CALL_TAG : String = "cancelCallMobile"


public let SOCKETIO_EVENT_GALLERY_REQUEST_TAG : String = "galleryRequestIOS"
public let SOCKETIO_EVENT_GALLERY_REQUEST_SUCCESS_TAG : String = "galleryRequestSucceed"
public let SOCKETIO_EVENT_GALLERY_REQUEST_FAIL_TAG : String = "galleryRequestFailed"

public let SOCKETIO_EVENT_MONITORING_REQUEST_TAG : String = "monitoringRequest"
public let SOCKETIO_EVENT_MONITORING_REQUESTE_SUCCESS_TAG : String = "monitoringRequestSucceed"
public let SOCKETIO_EVENT_MONITORING_REQUESTED_TAG : String = "monitoringRequested"
public let SOCKETIO_EVENT_MONITORING_REQUESTED_ACCEPTED_TAG : String = "monitoringRequestAccepted"
public let SOCKETIO_EVENT_MONITORING_REQUESTED_REFUSED_TAG : String = "monitoringRequestRefused"
public let SOCKETIO_EVENT_MONITORING_REQUESTED_NO_ACTIVITY_TAG : String = "noActivityRequest"

public let SOCKETIO_EVENT_MONITORING_REQUEST_BUSY_MASTER_TAG : String = "monitoringRequestBusyMaster"
public let SOCKETIO_EVENT_MONITORING_REQUEST_BUSY_SUBUSER_TAG : String = "monitoringRequestBusySubuser"
public let SOCKETIO_EVENT_MONITORING_REQUEST_FAILED_TAG : String = "monitoringRequestFailed"
public let SOCKETIO_EVENT_MONITORING_FORCE_CONNECTION_TAG : String = "monitoringForceConnection"
public let SOCKETIO_EVENT_MONITORING_FORCE_CONNECTION_FAILED_TAG : String = "monitoringRequestFailed"

public let SOCKETIO_EVENT_SEND_MESSAGE_TAG : String = "rtc_message"
public let SOCKETIO_EVENT_MESSAGE_BYE_TAG : String = "bye"
public let SOCKETIO_EVENT_MESSAGE_GOT_USER_MEDIA_TAG : String = "got user media"

public let SOCKETIO_EVENT_CREATE_OR_JOIN_TAG : String = "create_or_join"
public let SOCKETIO_EVENT_CREATED_TAG : String = "created"
public let SOCKETIO_EVENT_FULL_TAG : String = "full"
public let SOCKETIO_EVENT_JOIN_TAG : String = "join"
public let SOCKETIO_EVENT_JOINED_TAG : String = "joined"
public let SOCKETIO_EVENT_LOG_TAG : String = "log"
public let SOCKETIO_EVENT_MESSAGE_TAG : String = "rtc_message"
public let SOCKETIO_EVENT_LEAVE_TAG : String = "leave"
public let SOCKETIO_EVENT_LEAVING_TAG : String = "leaving"

//Call RPC error string
public let WONDERBOX_UNAUTHORIZED = "WonderBoxUnAuthorized"
public let WONDERBOX_CONTROLLER_IS_NO_HERE = "WonderBoxControllerIsNotHere"
public let CALL_RPC_USERSTRING_EXPIRED = "CallRpcUserStringExpired"
public let CALL_RPC_FAILED_USER_NOT_EXIST = "CallRpcFailedUserNotExist"
public let CALL_RPC_FAILED_WRONG_PWD = "CallRpcFailedWrongPwd"
public let CALL_RPC_FAILED_UNKNOW_ERROR = "CallRpcFailedUnknowError"

public let GET_NEW_USERSTRING_COUNT_MAX = 3


