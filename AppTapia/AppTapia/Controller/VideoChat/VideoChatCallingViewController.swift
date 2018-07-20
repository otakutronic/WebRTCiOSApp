//
//  VideoChatCallingViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import SwiftyJSON

class VideoChatCallingViewController: UIViewController {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var endButton: UIButton!
    
    public var contact = Contact()
    public var roomID:String = ""
    public var linkID:String = ""
    public var isInitiator:Bool = false
    public var sessionID:String = ""
    
    enum callType: String {
        case audioCall = "0"
        case videoCall = "1"
    }
    
    enum callErrorType: Int {
        case NOT_REACHEABLE
        case NOT_EXIST
        case CALL_FAILED
        
        var string: String {
            return String(describing: self)
        }
    }
    
    enum callStates: Int {
        case MESSAGE_VIDEO_STATE_RINGING
        case MESSAGE_USER_NOT_CONNECTED
        case MESSAGE_USER_BUSY
        
        var string: String {
            return String(describing: self)
        }
    }
    
    override func viewDidLoad() {
        
        print("VideoChatCallingViewController")
        
        nameLabel.text = contact.name
        stateLabel.text = NSLocalizedString("MESSAGE_VIDEO_STATE_CONNECTING", comment: "")
        
        //        "MESSAGE_VIDEO_STATE_RINGING" = "Ringing";
        //        "MESSAGE_VIDEO_STATE_CONNECTING" = "Connecting";
        //        "MESSAGE_VIDEO_STATE_CALLING" = "Calling";
        
        startCalling()
    }
    
    /// viewDidAppear
    ///
    /// - Parameter animated: <#animated description#>
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(false)
        
        //self.room = JSON(responseString)[0].stringValue // responseData?
        //print("room: \(self.room)")
    }
    
    /// endButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func endButtonClicked(_ sender: Any) {
        cancelCalling()
    }
    
    /// startCalling
    func startCalling() {
        
        print("contact.id: \(contact.id)")
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        let linkID:String = contact.id
        let typeOfCall:String = callType.videoCall.rawValue
        
        LibraryAPI.shared.makeCallRequest(token: token, linkID: linkID, callType: typeOfCall) {
            (responseString: String, responseData: [AnyObject]) in
            
            print("......responseString.......")
            print(responseString)
            print("......responseString.......")
            
            if (responseString == SOCKETIO_EVENT_CALL_REQUEST_CREATED_TAG) {
                
                let response:String = responseData[0] as! String
                print(response)
                self.sessionID = response
                
            } else if(responseString == SOCKETIO_EVENT_CALL_REQUEST_SUCCESS_TAG) {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.stateLabel.text = NSLocalizedString("MESSAGE_VIDEO_STATE_RINGING", comment: "")
                })
                
            } else if(responseString == SOCKETIO_EVENT_CALL_ACCEPTED_TAG) {
                
                // success
                
            } else if (responseString == SOCKETIO_EVENT_NEW_RTC_CONNECTION) {
                
                self.linkID = JSON(responseData)[0].stringValue
                self.roomID = JSON(responseData)[1].stringValue
                self.isInitiator = JSON(responseData)[2].boolValue
                
                print("linkID: \(self.linkID)")
                print("roomID:\(self.roomID)")
                print("isInitiator:\(self.isInitiator)")
                
                print("......performSegue.......")
                self.performSegue(withIdentifier: "VideoChatCallViewController", sender: self)
                
            }  else if(responseString == SOCKETIO_EVENT_CALL_REFUSED_TAG) {
                
                // self.cancelCalling()
                self.dismiss(animated: true, completion: nil)
                
            }  else if(responseString == SOCKETIO_EVENT_CALL_REQUEST_FAIL_TAG) {
                
                let errorCode:Int32 = responseData[0].int32Value
                print(errorCode)
                
                if let errorMessage = callErrorType(rawValue: Int(errorCode)) {
                    showWarningAlert(viewController: self, Message: NSLocalizedString(errorMessage.string, comment: ""), OkAction: nil)
                }
            }
        }
        
        
        //        let data:User = DataManager.currentUser
        //
        //        LibraryAPI.shared.callContact(object: data, contact: contact) {
        //            (responseString: String, responseData: [AnyObject]) in
        //
        //            print("Register result: \(responseString)")
        //
        //            if (responseString == SOCKETIO_EVENT_CALL_SUCCESS_TAG) {
        //                DispatchQueue.main.async(execute: { () -> Void in
        //                    self.stateLabel.text = NSLocalizedString("MESSAGE_VIDEO_STATE_RINGING", comment: "")
        //                })
        //            } else if responseString == SOCKETIO_EVENT_CALL_FAIL_TAG {
        //                showWarningAlert(viewController: self, Message: NSLocalizedString("MESSAGE_USER_NOT_CONNECTED", comment: ""), OkAction: nil)
        //            } else if responseString == SOCKETIO_EVENT_CALL_START_TAG {
        //                self.room = JSON(responseString)[0].stringValue // responseData?
        //                print("room: \(self.room)")
        //                self.performSegue(withIdentifier: "ShowVideoChatCallViewController", sender: nil)
        //
        //            } else if responseString == SOCKETIO_EVENT_CALL_BUSY_TAG {
        //                // ok action
        //                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) { UIAlertAction in
        //                    self.dismiss(animated: true, completion: nil)
        //                }
        //                showWarningAlert(viewController: self, Message: NSLocalizedString("MESSAGE_USER_BUSY", comment: ""), OkAction: okAction)
        //
        //            } else if responseString == SOCKETIO_EVENT_CALL_REJECT_TAG {
        //                self.dismiss(animated: true, completion: nil)
        //            }
        //        }
        
        //        socketIO_CallContact(myData: delegate.myData, contact: contact) { (responseString, responseData) in
        //            print("@@@@@ socketIO_CallContact:\(responseString)")
        //
        //            if responseString == SOCKETIO_EVENT_CALL_SUCCESS_TAG {
        //                DispatchQueue.main.async(execute: { () -> Void in
        //                    self.stateLabel.text = NSLocalizedString("MESSAGE_VIDEO_STATE_RINGING", comment: "")
        //                })
        //
        //
        //            } else if responseString == SOCKETIO_EVENT_CALL_FAIL_TAG {
        //                showWarningAlert(viewController: self, Message: NSLocalizedString("MESSAGE_USER_NOT_CONNECTED", comment: ""), OkAction: nil)
        //
        //
        //            } else if responseString == SOCKETIO_EVENT_CALL_START_TAG {
        //                self.room = JSON(responseData)[0].stringValue
        //                print("room: \(self.room)")
        //                self.performSegue(withIdentifier: "ShowVideoChatCallViewController", sender: nil)
        //
        //            } else if responseString == SOCKETIO_EVENT_CALL_BUSY_TAG {
        //                // ok action
        //                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) { UIAlertAction in
        //                    self.dismiss(animated: true, completion: nil)
        //                }
        //                showWarningAlert(viewController: self, Message: NSLocalizedString("MESSAGE_USER_BUSY", comment: ""), OkAction: okAction)
        //
        //            } else if responseString == SOCKETIO_EVENT_CALL_REJECT_TAG {
        //                self.dismiss(animated: true, completion: nil)
        //
        //            }
        
        // }
        
        
        //        socketIO_CallReject() { (responseString, responseData) in
        //            print("@@@@@ socketIO_CallReject:\(responseString)")
        //
        //            if responseString == SOCKETIO_EVENT_CALL_REJECT_TAG {
        //                self.dismissViewControllerAnimated(true, completion: nil)
        //                return
        //            }
        //
        //        }
        
    }
    
    /// cancelCalling
    func cancelCalling() {
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        LibraryAPI.shared.cancelCallRequest(token: token, sessionID: sessionID)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {
            
            case "VideoChatCallViewController":
                
                let nav = segue.destination as! UINavigationController
                
                guard let tapiaDetailViewController = nav.topViewController as? VideoChatCallViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                print("tapiaDetailViewController.contact")
                print(tapiaDetailViewController.contact)
                
                tapiaDetailViewController.contact = self.contact
                tapiaDetailViewController.roomID = self.roomID
                tapiaDetailViewController.isInitiator = self.isInitiator
                
                break
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
    }
}

