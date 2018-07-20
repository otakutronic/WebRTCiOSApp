//
//  MonitoringControlViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log
import RealmSwift
import AVFoundation
import SwiftyJSON
import WebRTC
import MBProgressHUD

class MonitoringControlViewController: UIViewController {
    
    @IBOutlet var remoteView: RTCEAGLVideoView!
    @IBOutlet var addPhotoBtn: UIButton!
    @IBOutlet var upBtn: UIButton!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var downBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    var takePictureHUD: MBProgressHUD!
    
    var remoteVideoTrack: RTCVideoTrack!

    var roomID:String = ""
    var contact = Contact()
    var callTime = 0
    var startTime: NSDate!
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MonitoringControlViewController")
        
         //remoteView.delegate = self;
        
        // setup()
        
        enableButtons()
    }
    
    /// enable buttons
    ///
    /// - Parameter enable: <#enable description#>
    func enableButtons(enable: Bool = true) {
        
        addPhotoBtn.isEnabled = enable
        upBtn.isEnabled = enable
        leftBtn.isEnabled = enable
        downBtn.isEnabled = enable
        rightBtn.isEnabled = enable
    }
    
    /// viewDidAppear
    ///
    /// - Parameter animated: <#animated description#>
    override func viewDidAppear(_ animated: Bool) {
        
        //if reachability.isReachable {
           // connectToTapia()
       //}else{
           // if self.HUD != nil {
             //   self.HUD.hide(animated: true)
           // }
            //showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_FIND_NO_INTERNAL", comment: ""), OkAction: nil)
       // }
        
        
    }
    
    /// viewDidDisappear
    ///
    /// - Parameter animated: <#animated description#>
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    /// initWebRTC
    func webRTCSetup() {
        LibraryAPI.shared.startRTC(view: self) {
            (responseString: String) in
            print("ready")
        }
    }
    
    /// didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftTouchDown(_ sender: Any) {
        print("button")
        sendStateButton(button: "right", state: true)
    }
    @IBAction func leftTouchUp(_ sender: Any) {
        print("button")
        sendStateButton(button: "right", state: false)
    }
    @IBAction func leftTouchUpOutside(_ sender: Any) {
        print("button")
        sendStateButton(button: "right", state: false)
    }
    
    @IBAction func upTouchDown(_ sender: Any) {
        print("button")
        sendStateButton(button: "up", state: true)
    }
    @IBAction func upTouchUp(_ sender: Any) {
        print("button")
        sendStateButton(button: "up", state: false)
    }
    @IBAction func upTouchUpOutside(_ sender: Any) {
        print("button")
        sendStateButton(button: "up", state: false)
    }
    
    @IBAction func rightTouchDown(_ sender: Any) {
        print("button")
        sendStateButton(button: "left", state: true)
    }
    @IBAction func rightTouchUp(_ sender: Any) {
        print("button")
        sendStateButton(button: "left", state: false)
    }
    @IBAction func rightTouchUpOutside(_ sender: Any) {
        
        sendStateButton(button: "left", state: false)
    }
    
    @IBAction func downTouchDown(_ sender: Any) {
         print("button")
        sendStateButton(button: "down", state: true)
    }
    @IBAction func downTouchUp(_ sender: Any) {
         print("button")
        sendStateButton(button: "down", state: false)
    }
    @IBAction func downTouchUpOutside(_ sender: Any) {
        sendStateButton(button: "down", state: false)
    }
    
    @IBAction func takePictureButtonClicked(_ sender: Any) {
        print("photo")
        sendStateButton(button: "photo", state: true)
    }
    
    /// sendStateButton
    ///
    /// - Parameters:
    ///   - button: <#button description#>
    ///   - state: <#state description#>
    func sendStateButton(button: String, state: Bool) {
        
        print("button: \(button)")
        print("state: \(state)")
        
        if button == "photo" && state {
            self.takePictureHUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
            self.takePictureHUD.mode = MBProgressHUDMode.indeterminate
            self.takePictureHUD.label.text = NSLocalizedString("MESSAGE_MONITORING_TAKING_PICTURE", comment: "")
            self.takePictureHUD.button.setTitle(NSLocalizedString("CANCEL", comment: ""), for: UIControlState.normal)
            self.takePictureHUD.button.addTarget(self, action: #selector(MonitoringControlViewController.cancelTakePictureHUD), for: .touchUpInside)

        }
        
        let value:String = (state) ? "true" : "false"
        
        sendMessage(type: button, value: value)
    }
    
    /// doneButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        print("Hanging up")
        
        //let token:String = LibraryAPI.shared.appData.sessionToken
        
        //LibraryAPI.shared.leaveRoom(token: token, roomID: roomID)
        
        //LibraryAPI.shared.stopRTC()
        
        //socketIO_Disconnect()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// setup
    func setup() {
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        LibraryAPI.shared.createOrJoinRoom(token: token, roomID: roomID) {
            (responseString: String, responseData: [AnyObject]) in
            
            // get room id in responseData
            if (responseString == SOCKETIO_EVENT_CREATED_TAG) {
                self.webRTCSetup()
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_FULL_TAG) {
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_JOIN_TAG) {
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_JOINED_TAG) {
                self.webRTCSetup()
                LibraryAPI.shared.makeOfferRTC()
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_LOG_TAG) {
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_MESSAGE_TAG) {
                // deal with message
                self.parseMessage(jsonObject: responseData)
            } else if(responseString == SOCKETIO_EVENT_LEAVE_TAG) {
                self.doneButtonClicked(self)
            }
        }
    }
    
    /// parseMessage
    ///
    /// - Parameters:
    ///   - responseData: jsonObject description
    func parseMessage(jsonObject: [AnyObject]) {
        
        //let roomNum = JSON(jsonObject)[0]
        let dataObject = JSON(jsonObject)[1]
        let jsonMessage = JSON.parse(dataObject.stringValue)
        let msgType = jsonMessage["msg_type"].stringValue
        
        switch (msgType) {
        case "sdp":
            let sdpType = jsonMessage["sdp_type"].stringValue
            let sdpDescription = jsonMessage["sdp_description"].stringValue
            
            if(sdpType == MsgFields.answer.rawValue) {
                LibraryAPI.shared.answerOfferRTC(sdpDescription: sdpDescription)
            } else if(sdpType == MsgFields.offer.rawValue) {
                LibraryAPI.shared.answerReceivedRTC(sdpDescription: sdpDescription)
            }
            break
        case MsgFields.candidate.rawValue:
            let sdp = jsonMessage["sdp"].stringValue
            let sdpMLineIndex = jsonMessage["sdpMLineIndex"].int32Value
            let sdpMid = jsonMessage["sdpMid"].stringValue
            LibraryAPI.shared.addIceRTC(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
            break
        default:
            return
        }
    }
    
    /// sendSDPMessage
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - sdp: <#sdp description#>
    func sendSDPMessage(type: String, sdp: String) {
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        let messageObject: JSON = [
            "msg_type": "sdp",
            "sdp_type": type,
            "sdp_description": sdp
        ]
        
        LibraryAPI.shared.RTCMessage(token: token, roomID: roomID, messageObject: messageObject)
    }
    
    /// sendIceCandidate
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - candidate: <#candidate description#>
    func sendIceCandidate(type: String, _ candidate: RTCIceCandidate) {
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        let messageObject: JSON = [
            "msg_type": MsgFields.candidate.rawValue,
            "sdp": candidate.sdp,
            "sdpMid": candidate.sdpMid!,
            "sdpMLineIndex": candidate.sdpMLineIndex
        ]
        
        LibraryAPI.shared.RTCMessage(token: token, roomID: roomID, messageObject: messageObject)
    }
    
    /// sendMessage
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - value: <#value description#>
    func sendMessage(type: String, value: String) {
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        let messageObject: JSON = [
            "msg_type": type,
            "value": value
        ]
        
        LibraryAPI.shared.RTCMessage(token: token, roomID: roomID, messageObject: messageObject)
    }
    
    /// cancelTakePictureHUD
    func cancelTakePictureHUD() {
        self.takePictureHUD.hide(animated: true)
        
    }
}

extension MonitoringControlViewController: RTCManagerDelegate {
    func rtcClient(client : RTCManager, didReceiveError error: Error) {
        // Error Received
        print("RTC client error.")
    }
    
    func rtcClient(client : RTCManager, didGenerateIceCandidate iceCandidate: RTCIceCandidate) {
        // iceCandidate generated, pass this to other user using signal method
        self.sendIceCandidate(type: MsgFields.candidate.rawValue, iceCandidate)
    }
    
    func rtcClient(client : RTCManager, type: String, startCallWithSdp sdp: String) {
        // SDP generated, pass this to other user using signal method
        self.sendSDPMessage(type: type, sdp: sdp)
    }
    
    func rtcClient(client : RTCManager, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack) {
        // Use localVideoTrack generated for rendering stream to remoteVideoView
    }
    
    func rtcClient(client : RTCManager, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
        // Use remoteVideoTrack generated for rendering stream to remoteVideoView
        remoteVideoTrack.add(self.remoteView)
        self.remoteVideoTrack = remoteVideoTrack
    }
}





