//
//  SettingDeleteAccountViewController.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/10/5.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingDeleteAccountViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var deleteButton: UIButton!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var HUD: MBProgressHUD!
    
    override func viewDidLoad() {
        
        titleLabel.text = NSLocalizedString("TITLE_ACCOUNT_DELETE", comment: "")
        contentTextView.text = NSLocalizedString("DELETE_ACCOUNT_TEXT", comment: "")
        //deleteButton.titleLabel?.text = NSLocalizedString("ACCOUNT_DELETE", comment: "")
    }
    
    
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        
        
        // ok action
        let okAction = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: UIAlertActionStyle.default) { UIAlertAction in
            
            self.HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
            self.HUD.mode = MBProgressHUDMode.indeterminate
            self.HUD.label.text = NSLocalizedString("LOADING", comment: "")
            let user = DataManager.currentUser
            socketIO_DeleteAccount(uuid: user.id) { (responseString, responseData) in
                print("@@@@@ socketIO_DeleteAccount:\(responseString)")
                self.HUD.hide(animated: true)
                if responseString == SOCKETIO_EVENT_DELETE_ACCOUNT_SUCCESS_TAG {
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_IS_FIRST_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_PHONE_NUMBER_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_UUID_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_EMAIL_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USERNAME_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SECRET_QUESTION_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SECRET_ANSWER_TAG)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_BASE_64_PROFILE_PICTURE_TAG)
                    UserDefaults.standard.synchronize()
                    
                    user.email = ""
                    user.phoneNumber = ""
                    user.secretQuestion = ""
                    user.secretAnswer = ""
                    user.name = ""
                    user.id = ""
                    user.profilePicture = ""
                    user.password = ""
                    
                    // delete all from DB here!!!
                    //ContactDao.sharedDao.removeAll()
                    //VideoHistoryDao.sharedDao.removeAll()
                    
                    do {
                        try FileManager.default.removeItem(atPath: SMALL_PICTURE_FOLDER_TAPIA)
                    }
                    catch let error as NSError {
                        print("Delete SMALL_PICTURE_FOLDER_TAPIA folder not found\n: \(error)")
                    }
                    
                    do {
                        try FileManager.default.removeItem(atPath: SMALL_PICTURE_FOLDER_MONITORING)
                    }
                    catch let error as NSError {
                        print("Delete SMALL_PICTURE_FOLDER_MONITORING folder not found\n: \(error)")
                    }
                    
                    do {
                        try FileManager.default.removeItem(atPath: PICTURE_FOLDER_TAPIA)
                    }
                    catch let error as NSError {
                        print("Delete PICTURE_FOLDER_TAPIA folder not found\n: \(error)")
                    }
                    
                    do {
                        try FileManager.default.removeItem(atPath: PICTURE_FOLDER_MONITORING)
                    }
                    catch let error as NSError {
                        print("Delete PICTURE_FOLDER_MONITORING folder not found\n: \(error)")
                    }
                    
                    self.dismiss(animated: false, completion: nil)
                    
                    self.performSegue(withIdentifier: "ShowUnwindToStartViewController", sender: self)
                    
                } else { //SOCKETIO_EVENT_DELETE_ACCOUNT_FAIL_TAG
                    
                    showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("SOCKETIO_EVENT_DELETE_ACCOUNT_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                    return
                }
                
                
            }
            
            
            
            

        }
        
        // cancel action
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) { UIAlertAction in
            
        }
        showConfirmAlert(viewController: self, Message: NSLocalizedString("CONFIRM_MESSAGE_DELETE_ALL_DATA", comment: ""), OkAction: okAction, CancelAction:  cancelAction)
        
        
    }
    
}
