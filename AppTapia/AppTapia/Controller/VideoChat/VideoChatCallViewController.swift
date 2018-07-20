//
//  VideoChatCallViewController.swift
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

class VideoChatCallViewController: UIViewController {
    
    @IBOutlet var remoteView: RTCEAGLVideoView!
    @IBOutlet var localView: RTCEAGLVideoView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var endButton: UIButton!
    
    var localVideoTrack: RTCVideoTrack!
    var remoteVideoTrack: RTCVideoTrack!

    var updateTextViewTimer: Timer?
    var callTime = 0
    var contact = Contact()
    var roomID:String = "604"
    var isInitiator:Bool = false
    
    var startTime: NSDate!
    
    var msgType:String = ""
    var sdpType:String = ""
    var sdpDescription:String = ""
    var sdp:String = ""
    var sdpMLineIndex:Int32 = 0
    var sdpMid:String = ""

    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = self.contact.name
        self.stateLabel.text = "Starting please wait"
        self.timeLabel.text = "00:00"

        self.setup()
    }

    /// didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// updateNowDateTimeTextView
    func updateNowDateTimeTextView() {
        
        let minutes = callTime/60
        let seconds = callTime%60
        callTime += 1
        DispatchQueue.main.async(execute: {
            self.timeLabel.text = String(format: "%02d : %02d", minutes, seconds)
        })
    }
    
    /// stopTimer
    func stopTimer() {
        if self.updateTextViewTimer != nil {
            self.updateTextViewTimer?.invalidate()
            self.updateTextViewTimer = nil
        }
    }

    /// save call history
    func saveChatHistory() -> Void {

        let contactID:String = contact.id
        let date:String = startTime.timeIntervalSince1970.description
        let id = date + String(arc4random_uniform(10000))
        let isInitiator:Bool = LibraryAPI.shared.rtcManager.isInitiator()
        let state:String = (isInitiator == true) ? VideoHistory.CallType.CALL_TYPE_OUTCOMINGSUCCESS.rawValue:
            VideoHistory.CallType.CALL_TYPE_INCOMINGSUCCESS.rawValue
        let length:String = String(NSDate().timeIntervalSince(startTime as Date))
        
        LibraryAPI.shared.saveVideoSession(id: id, contactID: contactID, date: date, state: state, length: length)
    }
    
    /// endButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func endButtonClicked(_ sender: Any) {
        
        print("Hanging up")
        
        stopTimer()
        
        remoteView.removeFromSuperview()
        localView.removeFromSuperview()

        let token:String = LibraryAPI.shared.appData.sessionToken
        
        LibraryAPI.shared.stopRTC()
        
        LibraryAPI.shared.leaveRoom(token: token, roomID: roomID)
        
        saveChatHistory()
        
        // socketIO_Disconnect()

        self.performSegue(withIdentifier: "unwindToVideoChat", sender: nil)
    }
    
    /// initWebRTC
    func webRTCSetup() {

        LibraryAPI.shared.startRTC(view: self) {
            (responseString: String) in

            self.nameLabel.text = self.contact.name
            self.stateLabel.text = NSLocalizedString("MESSAGE_VIDEO_STATE_CALLING", comment: "")
            self.timeLabel.text = "00:00"
            
            self.updateTextViewTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VideoChatCallViewController.updateNowDateTimeTextView), userInfo: nil, repeats: true)
            
            self.startTime = NSDate()
            
            if(self.isInitiator) {
                LibraryAPI.shared.makeOfferRTC()
            }
        }
    }
    
    /// setup
    func setup() {
        
        let token:String = LibraryAPI.shared.appData.sessionToken

        LibraryAPI.shared.createOrJoinRoom(token: token, roomID: roomID) {
            (responseString: String, responseData: [AnyObject]) in
            
            print("responseString: \(responseString)")
            print("responseData: \(responseData)")
            
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
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_LOG_TAG) {
                // get room id in responseData
            } else if(responseString == SOCKETIO_EVENT_MESSAGE_TAG) {
                // deal with message
                self.parseMessage(jsonObject: responseData)
            } else if(responseString == SOCKETIO_EVENT_LEAVING_TAG) {
                self.endButtonClicked(self)
            }
        }
    }
    
    /// Iterate through nested json data no matter how deep
    /// and set the values
    ///
    /// - Parameter jsonObject: <#jsonObject description#>
    func iterateThroughJson(jsonObject: JSON) {
        for (key, value):(String, JSON) in jsonObject {
            iterateThroughJson(jsonObject: value)
            setValues(key: key, val: value)
        }
    }
    
    /// setValues
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - val: <#val description#>
    func setValues(key: String, val: JSON) {
        switch (key) {
            case "sdp_type":
                sdpType = val.stringValue
                break
            case "sdp_description":
                sdpDescription = val.stringValue
                break
            case "msg_type":
                msgType = val.stringValue
                break
            case "sdp":
                sdp = val.stringValue
                break
            case "sdpMLineIndex":
                sdpMLineIndex = val.int32Value
                break
            case "sdpMid":
                sdpMid = val.stringValue
                break
            default:
                return
        }
    }
    
    /// parseMessage
    ///
    /// - Parameters:
    ///   - responseData: jsonObject description
    func parseMessage(jsonObject: [AnyObject]) {
        
        //let roomNum = JSON(jsonObject)[0]
        let dataObject = JSON(jsonObject)[1]

        iterateThroughJson(jsonObject: dataObject)

        print("---------------------------msgType:\(msgType)")
        
        switch (msgType) {
            case "sdp":
                //let sdpType = jsonMessage["sdp_type"].stringValue
                //let sdpDescription = jsonMessage["sdp_description"].stringValue
                if(sdpType == MsgFields.answer.rawValue) {
                    print("ANSWER!!!!!!!!!!!!!!!!!!")
                    LibraryAPI.shared.answerReceivedRTC(sdpDescription: sdpDescription)
                } else if(sdpType == MsgFields.offer.rawValue) {
                    LibraryAPI.shared.answerOfferRTC(sdpDescription: sdpDescription)
                    print("OFFER!!!!!!!!!!!!!!!!!!")
                }
                break
            case MsgFields.candidate.rawValue:
                //let sdp = jsonMessage["sdp"].stringValue
                //let sdpMLineIndex = jsonMessage["sdpMLineIndex"].int32Value
                //let sdpMid = jsonMessage["sdpMid"].stringValue
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
        
        print("sendSDPMessage......................................")
        
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
        
        print("sendIceCandidate......................................")
        
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
}

extension VideoChatCallViewController: RTCManagerDelegate {
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
        localVideoTrack.add(self.localView)
        self.localVideoTrack = localVideoTrack
    }
    
    func rtcClient(client : RTCManager, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
        // Use remoteVideoTrack generated for rendering stream to remoteVideoView
        remoteVideoTrack.add(self.remoteView)
        self.remoteVideoTrack = remoteVideoTrack
    }
}





