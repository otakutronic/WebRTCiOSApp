//
//  RegisterTableViewController.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/9/20.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import UIKit
//import PhoneNumberKit
//import MBProgressHUD

enum DisplayMode: String {
    case DISPLAY_MODE_NEW = "DISPLAY_MODE_NEW"
    case DISPLAY_MODE_EDIT = "DISPLAY_MODE_EDIT"
}

class RegisterTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PatternLockDelegate {

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var secretQuestionLabel: UILabel!
    @IBOutlet var secretAnswerLabel: UILabel!
    @IBOutlet var signUpButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    //let phoneNumberKit = PhoneNumberKit()
    var HUD: MBProgressHUD!
    var okAlertAction: UIAlertAction!
    var displayMode = DisplayMode.DISPLAY_MODE_NEW
    var textFieldA, textFieldConfirm: UITextField!
    var newData: MyData!
    
    
    
//    // MARK: - Portrait only
//    func shouldAutorotate() -> Bool {
//        return false
//    }
//    
//    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }

    
    override func viewDidLoad() {
        
        imagePicker.delegate = self
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterTableViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        if displayMode == .DISPLAY_MODE_NEW {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
        
        newData = MyData()
        
        if delegate.myData.base64ProfilePicture != "" {
            if let dataDecoded:Data = Data(base64Encoded: delegate.myData.base64ProfilePicture) {
                if let decodedimage:UIImage = UIImage(data: dataDecoded) {
                    photoImageView.image = decodedimage
                }
            }
        }
        if delegate.myData.myUsername != "" {
            newData.myUsername = delegate.myData.myUsername
            nameLabel.text = delegate.myData.myUsername
        }
        if delegate.myData.myPhoneNumber != "" {
            newData.myPhoneNumber = delegate.myData.myPhoneNumber
            phoneNumLabel.text = delegate.myData.myPhoneNumber
        }
        if delegate.myData.myEmail != "" {
            newData.myEmail = delegate.myData.myEmail
            emailLabel.text = delegate.myData.myEmail
        }
        if delegate.myData.mySecretQuestion != "" {
            newData.mySecretQuestion = delegate.myData.mySecretQuestion
            secretQuestionLabel.text = delegate.myData.mySecretQuestion
        }
        if delegate.myData.mySecretAnswer != "" {
            newData.mySecretAnswer = delegate.myData.mySecretAnswer
        }
        
    }
    
    
    
    //Calls this function when the tap is recognized.
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            if indexPath.row == 0 { //name
                let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message: NSLocalizedString("INPUT_MESSAGE_INPUT_NAME", comment: ""), preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: { (textField) -> Void in
                    NotificationCenter.default.addObserver(self, selector: #selector(RegisterTableViewController.handleTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                })
                
                
                okAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action) in
                    let textField = alert.textFields![0]
                    
                    if self.displayMode == .DISPLAY_MODE_NEW {
                        self.newData.myUsername = textField.text!
                        self.nameLabel.text = textField.text!
                        
                    } else {
                        socketIO_ChangeName(uuid: self.delegate.myData.myUUID, name: self.delegate.myData.myUsername) { (responseString, responseData) in
                            print("@@@@@ socketIO_ChangeName:\(responseString)")
                            if responseString == SOCKETIO_EVENT_CHANGE_NAME_SUCCESS_TAG {
                                
                                self.newData.myUsername = textField.text!
                                self.nameLabel.text = textField.text!
                                
                                self.delegate.myData.myUsername = self.newData.myUsername
                                UserDefaults.standard.set(self.newData.myUsername, forKey: USER_DEFAULT_USERNAME_TAG)
                                UserDefaults.standard.synchronize()
                                
                            } else { //SOCKETIO_EVENT_CHANGE_NAME_FAIL_TAG
                                
                                showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("ERROR_MESSAGE_CHANGE_NAME_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                                return
                            }
                            
                        }
                        
                    }
                    

                    }
                )
                okAlertAction.isEnabled = false
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                }
                
                alert.addAction(okAlertAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            } else if indexPath.row == 1 { //phone number

                
            } else if indexPath.row == 2 { //email
                let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: ""), preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: { (textField) -> Void in
                    NotificationCenter.default.addObserver(self, selector: #selector(RegisterTableViewController.handleTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                })
                
                
                okAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action) in
                    let textField = alert.textFields![0]
                    
                    if self.displayMode == .DISPLAY_MODE_NEW {
                        self.newData.myEmail = textField.text!
                        self.emailLabel.text = textField.text!
                        
                    } else {
                        socketIO_ChangeEmail(uuid: self.delegate.myData.myUUID, email: self.delegate.myData.myEmail) { (responseString, responseData) in
                            print("@@@@@ socketIO_ChangeEmail:\(responseString)")
                            if responseString == SOCKETIO_EVENT_CHANGE_EMAIL_SUCCESS_TAG {
                                
                                self.newData.myEmail = textField.text!
                                self.emailLabel.text = textField.text!
                                
                                self.delegate.myData.myEmail = self.newData.myEmail
                                UserDefaults.standard.set(self.newData.myEmail, forKey: USER_DEFAULT_EMAIL_TAG)
                                UserDefaults.standard.synchronize()
                                
                            } else { //SOCKETIO_EVENT_CHANGE_EMAIL_FAIL_TAG
                                
                                showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("ERROR_MESSAGE_CHANGE_EMAIL_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                                return
                            }
                            
                        }
                        
                    }
                    
                    
                    }
                )
                okAlertAction.isEnabled = false
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                }
                
                alert.addAction(okAlertAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            } else if indexPath.row == 3 { //secretQ
                let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message: NSLocalizedString("INPUT_MESSAGE_INPUT_SECRET_QUESTION", comment: ""), preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: { (textField) -> Void in
                    NotificationCenter.default.addObserver(self, selector: #selector(RegisterTableViewController.handleTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                })
                
                
                okAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action) in
                    let textField = alert.textFields![0]
                    
                    if self.displayMode == .DISPLAY_MODE_NEW {
                        self.newData.mySecretQuestion = textField.text!
                        self.secretQuestionLabel.text = textField.text!
                        
                    } else {
                        socketIO_ChangeSecretQ(uuid: self.delegate.myData.myUUID, secretQ: self.delegate.myData.mySecretQuestion) { (responseString, responseData) in
                            print("@@@@@ socketIO_ChangeSecretQ:\(responseString)")
                            if responseString == SOCKETIO_EVENT_CHANGE_SECRET_Q_SUCCESS_TAG {
                                
                                self.newData.mySecretQuestion = textField.text!
                                self.secretQuestionLabel.text = textField.text!
                                
                                self.delegate.myData.mySecretQuestion = self.newData.mySecretQuestion
                                UserDefaults.standard.set(self.newData.mySecretQuestion, forKey: USER_DEFAULT_SECRET_QUESTION_TAG)
                                UserDefaults.standard.synchronize()
                                
                            } else { //SOCKETIO_EVENT_CHANGE_SECRET_Q_FAIL_TAG
                                
                                showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("ERROR_MESSAGE_CHANGE_SECRET_Q_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                                return
                            }
                            
                        }
                        
                    }
                    
                    
                    }
                )
                okAlertAction.isEnabled = false
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                }
                
                alert.addAction(okAlertAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            } else if indexPath.row == 4 { //secretA
                let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message: NSLocalizedString("INPUT_MESSAGE_INPUT_SECRET_ANSWER", comment: ""), preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: { (textField) -> Void in
                    NotificationCenter.default.addObserver(self, selector: #selector(RegisterTableViewController.handleTwoTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                    textField.isSecureTextEntry = true
                    textField.placeholder = "秘密の答え"
                    self.textFieldA = textField
                })
                alert.addTextField(configurationHandler: { (textField) -> Void in
                    NotificationCenter.default.addObserver(self, selector: #selector(RegisterTableViewController.handleTwoTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                    textField.isSecureTextEntry = true
                    textField.placeholder = "秘密の答え（確認）"
                    self.textFieldConfirm = textField
                })
                
                okAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action) in
                    self.textFieldA = alert.textFields![0]
                    self.textFieldConfirm = alert.textFields![1]
                    self.newData.mySecretAnswer = self.textFieldA.text!
                    
                    if self.displayMode == .DISPLAY_MODE_NEW {
                        self.newData.mySecretAnswer = self.textFieldA.text!
                        
                    } else {
                        socketIO_ChangeSecretA(uuid: self.delegate.myData.myUUID, secretA: self.delegate.myData.mySecretAnswer) { (responseString, responseData) in
                            print("@@@@@ socketIO_ChangeSecretA:\(responseString)")
                            if responseString == SOCKETIO_EVENT_CHANGE_SECRET_A_SUCCESS_TAG {
                                
                                self.newData.mySecretAnswer = self.textFieldA.text!
                                
                                self.delegate.myData.mySecretAnswer = self.newData.mySecretAnswer
                                UserDefaults.standard.set(self.newData.mySecretAnswer, forKey: USER_DEFAULT_SECRET_ANSWER_TAG)
                                UserDefaults.standard.synchronize()
                                
                            } else { //SOCKETIO_EVENT_CHANGE_SECRET_A_FAIL_TAG
                                
                                showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("ERROR_MESSAGE_CHANGE_SECRET_A_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                                return
                            }
                            
                        }
                        
                    }
                    
                    
                    }
                )
                okAlertAction.isEnabled = false
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                }
                
                alert.addAction(okAlertAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
        

    }
    
    
    //handler
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        okAlertAction!.isEnabled = textField.text!.characters.count > 0
    }
    
    func handleTwoTextFieldTextDidChangeNotification(notification: NSNotification) {
        if textFieldA.text!.characters.count > 0 && textFieldConfirm.text!.characters.count > 0 {
            if textFieldA.text! == textFieldConfirm.text! {
                okAlertAction!.isEnabled = true
            } else {
                okAlertAction!.isEnabled = false
            }
            
        } else {
            okAlertAction!.isEnabled = false
        }
    }
    
    
    
    // MARK: - Button click event
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func setPasscodeButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowPatternLockViewController", sender: nil)
    }
    
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if (newData.myUsername == "") || (newData.myPhoneNumber == "") || (newData.mySecretQuestion == "") || (newData.mySecretAnswer == ""){
            
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_REGISTER_DATA_ERROR", comment: ""), OkAction: nil)
            return
        }
        

        if newData.mypassword != "" {
            
            delegate.myData.myUsername = newData.myUsername
            delegate.myData.myPhoneNumber = newData.myPhoneNumber
            delegate.myData.myEmail = newData.myEmail
            delegate.myData.mySecretQuestion = newData.mySecretQuestion
            delegate.myData.mySecretAnswer = newData.mySecretAnswer
            delegate.myData.mypassword = newData.mypassword
            
            if displayMode == .DISPLAY_MODE_NEW {
                doRegister()
                
            } else {    //DISPLAY_MODE_EDIT
                UserDefaults.standard.set(self.delegate.myData.myUsername, forKey: USER_DEFAULT_USERNAME_TAG)
                UserDefaults.standard.set(self.delegate.myData.myEmail, forKey: USER_DEFAULT_EMAIL_TAG)
                UserDefaults.standard.set(self.delegate.myData.mySecretQuestion, forKey: USER_DEFAULT_SECRET_QUESTION_TAG)
                UserDefaults.standard.set(self.delegate.myData.mySecretAnswer, forKey: USER_DEFAULT_SECRET_ANSWER_TAG)
                UserDefaults.standard.set(self.delegate.myData.base64ProfilePicture, forKey: USER_DEFAULT_BASE_64_PROFILE_PICTURE_TAG)
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: true, completion: nil)
            
            }

            
        } else {
            
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_NEED_LOGIN_PASSCODE", comment: ""), OkAction: nil)
            return
            
        }
        
    }
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let resizedImage = resizeImage(image: pickedImage, newWidth: 240)
            photoImageView.clipsToBounds = true
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.image = resizedImage
            
            //Save image
            if let imageData = UIImagePNGRepresentation(resizedImage) {
                let strBase64:String = imageData.base64EncodedString()
                self.delegate.myData.base64ProfilePicture = strBase64
                UserDefaults.standard.set(self.delegate.myData.base64ProfilePicture, forKey: USER_DEFAULT_BASE_64_PROFILE_PICTURE_TAG)
                UserDefaults.standard.synchronize()
                
            } else {
                
                showWarningAlert(viewController: self, Message: "Get photo failed.", OkAction: nil)
            }
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    // MARK: -  Do Register
    private func doRegister(){
        HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("LOADING", comment: "")

        if delegate.myData.mypassword != "" {
            
            socketIO_Register(myData: delegate.myData) { (responseString, responseData) in
                print("@@@@@ socketIORegister:\(responseString)")
                
                if responseString == SOCKETIO_EVENT_REGISTER_SUCCESS_TAG {
                    
                    UserDefaults.standard.set(self.delegate.myData.myUsername, forKey: USER_DEFAULT_USERNAME_TAG)
                    UserDefaults.standard.set(self.delegate.myData.myPhoneNumber, forKey: USER_DEFAULT_PHONE_NUMBER_TAG)
                    UserDefaults.standard.set(self.delegate.myData.myEmail, forKey: USER_DEFAULT_EMAIL_TAG)
                    UserDefaults.standard.set(self.delegate.myData.mySecretQuestion, forKey: USER_DEFAULT_SECRET_QUESTION_TAG)
                    UserDefaults.standard.set(self.delegate.myData.mySecretAnswer, forKey: USER_DEFAULT_SECRET_ANSWER_TAG)
                    UserDefaults.standard.set(self.delegate.myData.base64ProfilePicture, forKey: USER_DEFAULT_BASE_64_PROFILE_PICTURE_TAG)
                    
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: "ShowMainTabBarController", sender: nil)
                    
                } else { //SOCKETIO_EVENT_REGISTER_FAIL_TAG
                    
                    showWarningAlert(viewController: self, Message: String(format: NSLocalizedString("ERROR_MESSAGE_REGISTER_FAIL", comment: ""), responseData[0] as! String), OkAction: nil)
                    return
                }
                
            }
            
        } else {
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_NEED_LOGIN_PASSCODE", comment: ""), OkAction: nil)
            return
        }
        

    }
    
    
    // MARK: - PatternLockDelegate
    func resultOfPatternLock(resultType: PatternLockResultType, patternString: String) {
        print("PatternLockResult:\(resultType)")
        
        //        self.myActivityIndicatorView.stopAnimating()
        //        self.setViewWait()
        
        switch displayMode {
        case .DISPLAY_MODE_NEW:
            
            switch resultType {
            case .RESULT_TYPE_OK:
                newData.mypassword = patternString
                break
            case .RESULT_TYPE_FAIL:
                showWarningAlert(viewController: self, Message: NSLocalizedString("SET_PASSCODE_FAILED", comment: ""), OkAction: nil)
                break
            case .RESULT_TYPE_CANCEL:
                
                break
            }
            
            break
        case .DISPLAY_MODE_EDIT:
            
            switch resultType {
            case .RESULT_TYPE_OK:
                delegate.myData.mypassword = patternString
                
                break
            case .RESULT_TYPE_FAIL:
                showWarningAlert(viewController: self, Message: NSLocalizedString("CHANGE_PASSCODE_FAILED", comment: ""), OkAction: nil)
                break
            case .RESULT_TYPE_CANCEL:
                
                break
            }
            break
        }
        
        
        
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowPatternLockViewController") {
            let navigationController = segue.destination as! UINavigationController
            let lockVC = navigationController.topViewController as! PatternLockViewController
            if displayMode == .DISPLAY_MODE_NEW {
                lockVC.showLockStatus = ShowLockStatus.SHOW_LOCK_STATUS_SET_PATTERN
            } else {
                lockVC.showLockStatus = ShowLockStatus.SHOW_LOCK_STATUS_CHANGE_PATTERN
            }
            lockVC.patternLockDelegate = self
        }
    }
    
    
    
    
}
