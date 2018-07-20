//
//  CallPopupViewController.swift
//  AppTapia
//
//  Created by Andy on 01/11/17.
//

import SwiftyJSON

class CallPopupViewController: VideoChatCallingViewController {
    
    override func viewDidLoad() {
        
        print("CallPopupViewController")
        
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
    @IBAction override func endButtonClicked(_ sender: Any) {
        cancelCalling()
    }
    
    /// startCalling
    override func startCalling() {
        
        print("something happens here")
        
        nameLabel.text = contact.name + " calling"
        
    }
    
    /// cancelCall
    override func cancelCalling() {
        
        print("Cancel call clicked")
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        LibraryAPI.shared.refuseCallRequest(token: token, sessionID: sessionID)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// acceptCall
    func acceptCalling() {
        
        print("Accept call clicked")
        
        let token:String = LibraryAPI.shared.appData.sessionToken
        
        LibraryAPI.shared.acceptCallRequest(token: token, sessionID: sessionID) {
            (responseString: String, responseData: [AnyObject]) in
            
            print("Call accept response: \(responseString)")
            
            // react to accept response
            if (responseString == SOCKETIO_EVENT_CALL_ACCEPT_SUCCESS_TAG) {
                
                // success
                
            } else if (responseString == SOCKETIO_EVENT_CALL_ACCEPT_FAIL_TAG) {
                
                self.nameLabel.text = "Call failed"
                
                let errorMessage:String = responseData[0].stringValue
                print(errorMessage)
                showWarningAlert(viewController: self, Message: NSLocalizedString(errorMessage, comment: ""), OkAction: nil)
                
            } else if (responseString == SOCKETIO_EVENT_NEW_RTC_CONNECTION) {
                
                self.linkID = JSON(responseData)[0].stringValue
                self.roomID = JSON(responseData)[1].stringValue
                self.isInitiator = JSON(responseData)[2].boolValue
                
                print("linkID: \(self.linkID)")
                print("roomID:\(self.roomID)")
                print("isInitiator:\(self.isInitiator)")
                
                print("......performSegue.......")
                self.performSegue(withIdentifier: "VideoChatCallViewController", sender: self)
            }
        }
    }
    
    /// acceptButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func acceptButtonClicked(_ sender: Any) {
        acceptCalling()
    }
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        switch(segue.identifier ?? "") {
//
//        case VIDEO_CHAT_SCREEN_ID:
//
//            print("Displaying screen: \(VIDEO_CHAT_SCREEN_ID)")
//
//        default:
//            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
//        }
//    }
}

