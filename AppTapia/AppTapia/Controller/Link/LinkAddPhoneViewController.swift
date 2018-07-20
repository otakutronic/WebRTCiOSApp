//
//  LinkAddPhoneViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import SwiftyJSON
import PhoneNumberKit
import MBProgressHUD

class LinkAddPhoneViewController: UIViewController {
    
    @IBOutlet var phoneNumTextField: PhoneNumberTextField!

    var HUD: MBProgressHUD!
    //let delegate = UIApplication.shared.delegate as! AppDelegate
    let phoneNumberKit = PhoneNumberKit()
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LinkAddPhoneViewController")

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LinkAddPhoneViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    /// didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// sendButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        print("sendButtonClicked")
        
        if let number = phoneNumTextField.text {
            if number == "" {
                showWarningAlert(viewController: self, Message: "Phone number must has value", OkAction: nil)
                return
            }

            do {
                
                let phoneNumber = try phoneNumberKit.parse(number, withRegion: "JP")
                let formattedNumber = phoneNumberKit.format(phoneNumber, toType: .international, withPrefix: true)
                print("formattedNumber:\(formattedNumber)")

                phoneNumTextField.text = formattedNumber
                //delegate.myData.myPhoneNumber = formattedNumber

                HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
                HUD.mode = MBProgressHUDMode.indeterminate
                HUD.label.text = NSLocalizedString("LOADING", comment: "")
                
                let id:String = DataManager.currentUser.id

                LibraryAPI.shared.addPhoneNumberRequest(uuid: id, phoneNumber: formattedNumber) {
                    (responseString: String, responseData: [AnyObject]) in

                    self.HUD.hide(animated: true)
                    print("Add phone number result: \(responseString)")

                    if (responseString == SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG) {

                    } else { //SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG

                    }
//
////                socketIO_AddRequest(uuid: delegate.myData.myUUID, phoneNumber: formattedNumber) { (responseString, responseData) in
////                    print("@@@@@ socketIO_AddRequest:\(responseString)")
////                    self.HUD.hide(animated: true)
////                    if responseString == SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG {
////
//////                        try {
//////                            JSONObject jsonObject = new JSONObject(args[0].toString());
//////                            newContact.setNumber(jsonObject.getString("number"));
//////                            newContact.setName(jsonObject.getString("name"));
//////                            newContact.setState(Contact.REQUESTED);
//////                            contactDAO.addContact(newContact);
//////                            Data.myContacts.add(newContact);
//////                            //Data.myContacts.add(contactDAO.getContactByNumber(newContact.getNumber()));
//////                            activity.showFragment(new PhoneLinkSuccessFragment(), true);
//////                        }catch (JSONException e){
//////
//////                        }
////
////                        var number = JSON(responseData)[0]["number"].stringValue
////                        var name = JSON(responseData)[0]["name"].stringValue
////
////                        var contact = Contact()
////                        contact.name = name
////                        contact.number = number
////                        contact.state = "1"
////
////                        ContactDao.sharedDao.insert(box: contact)
////                        self.performSegue(withIdentifier: "ShowUnwindToMainTabBarController", sender: nil)
////
////
////                    } else { //SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG
////                        //this contact doesn't exist
////
////                        var error = responseData[0] as? String
////
////                        if error == "already registered" {
////
////                            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_LINK_PHONE_ALREADY_REGISTERED", comment: ""), OkAction: nil)
////
////                        } else if error == "tapia user not found" {
////                            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_LINK_PHONE_NOT_FOUND", comment: ""), OkAction: nil)
////
////
////                        }
////
////                        return
////                    }
////
////
                }
//
//
//
            } catch {
                showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_ILLEAGE_PHONE_NUMBER", comment: ""), OkAction: nil)
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
    
}
