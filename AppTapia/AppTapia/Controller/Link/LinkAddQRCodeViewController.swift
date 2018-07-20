//
//  LinkAddQRCodeViewController.swift
//  AppTapia
//
//  Created by Andy on 01/11/17.
//

import UIKit
import AVFoundation
import MBProgressHUD
import SwiftyJSON

class LinkAddQRCodeViewController: UIViewController {

    var HUD: MBProgressHUD!

    var newContact = Contact()

    /// viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        LibraryAPI.shared.startQRCodeReader(view: view, viewController: self) {
            (responseString: String) in
            
            if (responseString != "SETUP_OK") {
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) { UIAlertAction in
                    self.dismiss(animated: false, completion: nil)
                }
                
                showWarningAlert(viewController: self, Message: NSLocalizedString(responseString, comment: ""), OkAction: okAction)
            } else {
                
            }
        }
    }
    
    /// didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// cancelButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    /// Add QRCode
    ///
    /// - Parameter qrcode: <#qrcode description#>
    public func addQRCode(state: QRCodeReaderState, val: String) {
        
        print("QR code: \(val)")
        
        if(state == QRCodeReaderState.bad_code) {
            showWarningAlert(viewController: self, Message: val, OkAction: nil)
        }

        HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("LOADING", comment: "")
        
        let token = LibraryAPI.shared.appData.sessionToken
        
        LibraryAPI.shared.addQRCode(token: token, qrcode: val) {
            (responseString: String, responseData: [AnyObject]) in
            
            self.HUD.hide(animated: true)
            
            print("QR code add result: \(responseString)")
            print("responseData: \(responseData)")

            if (responseString == SOCKETIO_EVENT_REQUEST_QRCODE_SUCCESS_TAG) {
                
                let dataObject = JSON(responseData)[0]
                self.newContact = Contact(with: dataObject)
                self.newContact.id = "-1"
                
                LibraryAPI.shared.setContactData(newContact: self.newContact)
                
                self.performSegue(withIdentifier: "LinkAddQRCodeSuccessViewController", sender: nil)
                
            } else { //SOCKETIO_EVENT_ADD_QRCODE_FAIL_TAG
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) { UIAlertAction in
                    self.dismiss(animated: false, completion: nil)
                }
                
                showWarningAlert(viewController: self, Message: NSLocalizedString(responseString, comment: ""), OkAction: okAction)
                
                //////if responseData[0] as! String == "already registered" {
                    //////print("already registered")
                    ///showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("ERROR_MESSAGE_ADD_QRCODE_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                //////} else if responseData[0] as! String == "tapia user not found" {
                    //showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_ADD_QRCODE_TAPIA_NOT_FOUND", comment: ""), OkAction: nil)
                    //////print("tapia user not found")

                //////}
                
                //LibraryAPI.shared.restartQRCodeReader()

                //self.captureSession?.startRunning()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "LinkAddQRCodeSuccessViewController") {
            if let addSuccessVC = segue.destination as? LinkAddQRCodeSuccessViewController {
                addSuccessVC.newContactName = newContact.name
            }
        }

    }

}

extension LinkAddQRCodeViewController: QRCodeReaderDelegate {

    func qrCodeReader(reader : QRCodeReader, state: QRCodeReaderState, val: String) {
        // QR code add
        self.addQRCode(state: state, val: val)
    }
}
