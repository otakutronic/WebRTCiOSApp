//
//  RegisterTableViewController.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import UIKit
import MBProgressHUD

enum DisplayMode: String {
    case DISPLAY_MODE_REGISTERATION = "DISPLAY_MODE_REGISTERATION"
    case DISPLAY_MODE_EDIT_PROFILE = "DISPLAY_MODE_EDIT_PROFILE"
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
    var HUD: MBProgressHUD!
    var okAlertAction: UIAlertAction!
    var displayMode = DisplayMode.DISPLAY_MODE_REGISTERATION
    var textFieldA, textFieldConfirm: UITextField!
    
    /// viewDidLoad
    override func viewDidLoad() {

        imagePicker.delegate = self

        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterTableViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        if displayMode == .DISPLAY_MODE_REGISTERATION {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
            showCurrentUserProfile()
        }
    }
    
    //MARK: - Private method
    private func showCurrentUserProfile() {
        let currentUser:User = DataManager.currentUser
        
        if !currentUser.profilePicture.isEmpty {
            if let dataDecoded:Data = Data(base64Encoded: currentUser.profilePicture) {
                if let decodedimage:UIImage = UIImage(data: dataDecoded) {
                    photoImageView.image = decodedimage
                }
            }
        }
        
        if !currentUser.name.isEmpty {
            nameLabel.text = currentUser.name
        }
        if !currentUser.phoneNumber.isEmpty {
            phoneNumLabel.text = currentUser.phoneNumber
        }
        if !currentUser.email.isEmpty {
            emailLabel.text = currentUser.email
        }
        if !currentUser.secretQuestion.isEmpty {
            secretQuestionLabel.text = currentUser.secretQuestion
        }
    }
    
    private func setTextRowAt(indexPath: IndexPath) {
        if indexPath.row == 0 { //name
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_NAME", comment: "")) { newName in
                self.nameLabel.text = newName
                DataManager.currentUser.name = newName
            }
        } else if indexPath.row == 1 { //phoneNumber
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_NAME", comment: "")) { newNumber in
                self.phoneNumLabel.text = newNumber
                DataManager.currentUser.phoneNumber = newNumber
            }
        } else if indexPath.row == 2 { //email
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: "")) { newEmail in
                self.emailLabel.text = newEmail
                DataManager.currentUser.email = newEmail
            }
        } else if indexPath.row == 3 { //secretQ //TODO: Change localized string
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: "")) { newSecretQ in
                self.secretQuestionLabel.text = newSecretQ
                DataManager.currentUser.secretQuestion = newSecretQ
            }
        } else if indexPath.row == 4 { //secretA //TODO: Change localized string
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: "")) { newSecretA in
                self.secretAnswerLabel.text = newSecretA
                DataManager.currentUser.secretAnswer = newSecretA
            }
        }
    }
    
    private func setTextAndUpdateProfileRowAt(indexPath: IndexPath) {
        if indexPath.row == 0 { //name
            
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_NAME", comment: "")) { newName in
                LibraryAPI.shared.changeName(ID: DataManager.currentUser.id, newUsername: newName, success: { _ in
                    self.nameLabel.text = newName
                }, failure: { _ in
                    //TODO: Show an error message.
                })
            }
            
        } else if indexPath.row == 1 { //phoneNumber
            //TODO: ?
        } else if indexPath.row == 2 { //email
            
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: "")) { newEmail in
                LibraryAPI.shared.changeMail(ID: DataManager.currentUser.id, emilAddress: newEmail,  success: { _ in
                    self.emailLabel.text = newEmail
                }, failure: { _ in
                    //TODO: Show an error message.
                })
            }
            
        } else if indexPath.row == 3 { //secretQ
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: "")) { newSecretQ in
                LibraryAPI.shared.changeSecretQ(ID: DataManager.currentUser.id, question: newSecretQ,   success: { _ in
                    self.secretQuestionLabel.text = newSecretQ
                }, failure: { _ in
                    //TODO: Show an error message.
                })
            }
        } else if indexPath.row == 4 { //secretA
            self.presentAlertTextField(alertTitle: NSLocalizedString("INPUT_MESSAGE_INPUT_EMAIL", comment: "")) { newSecretA in
                LibraryAPI.shared.changeSecretA(ID: DataManager.currentUser.id, answer: newSecretA, success: { _ in
                    self.secretAnswerLabel.text = newSecretA
                }, failure: { _ in
                    //TODO: Show an error message.
                })
            }
        }
    }
    
    private func getAlertTextField(text: String) -> UIAlertController {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
                NotificationCenter.default.addObserver(self, selector: #selector(RegisterTableViewController.handleTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
            })

        return alert
    }
    
    private func presentAlertTextField(alertTitle: String, userHandler: @escaping ((String) -> Swift.Void)) {
        let alert = getAlertTextField(text: alertTitle)
        okAlertAction = UIAlertAction(title: NSLocalizedString("CONFIRM", comment: ""), style: .default, handler: { (action) in
            guard let textFields = alert.textFields,
                let text = textFields[0].text
                else { return }
            userHandler(text)
        })
        okAlertAction.isEnabled = false
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        alert.addAction(okAlertAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1 { //profileImage
            return
        }
        if displayMode == .DISPLAY_MODE_REGISTERATION {
            setTextRowAt(indexPath: indexPath)
        } else {
            setTextAndUpdateProfileRowAt(indexPath: indexPath)
        }
    }
    
    //handler
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        if let textField = notification.object as! UITextField? {
            okAlertAction!.isEnabled = !textField.text!.isEmpty
        }
    }
    
    func handleTwoTextFieldTextDidChangeNotification(notification: NSNotification) {
        if textFieldA.text!.count > 0 && textFieldConfirm.text!.count > 0 {
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
    /// changeButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func changeButtonClicked(_ sender: Any) {
        print("changeButtonClicked")
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// setPasscodeButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func setPasscodeButtonClicked(_ sender: Any) {
        print("setPasscodeButtonClicked")
        self.performSegue(withIdentifier: "PatternLockViewController", sender: nil)
    }
    
    /// signUpButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if !isUserDataValid() { return }
        
        if displayMode == .DISPLAY_MODE_REGISTERATION {
            doRegister()
        } else {    //DISPLAY_MODE_EDIT
            LibraryAPI.shared.saveUserData()
        }
    }
    
    private func isUserDataValid() -> Bool {
        let user = DataManager.currentUser
        if (user.name.isEmpty) || (user.phoneNumber.isEmpty) || (user.secretQuestion.isEmpty) || (user.secretAnswer.isEmpty) {
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_REGISTER_DATA_ERROR", comment: ""), OkAction: nil)
            return false
        } else if (user.password.isEmpty) {
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_NEED_LOGIN_PASSCODE", comment: ""), OkAction: nil)
            return false
        }
        
        return true
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
                DataManager.currentUser.profilePicture = strBase64
                if displayMode == .DISPLAY_MODE_EDIT_PROFILE {
                    LibraryAPI.shared.saveUserData()
                }
                
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
        HUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("LOADING", comment: "")
        
        let user = DataManager.currentUser
        
        LibraryAPI.shared.register(
            newUser: user,
            success: { (responseData) in
                self.HUD.hide(animated: true)
                LibraryAPI.shared.saveUserData()
                self.performSegue(withIdentifier: "MainTabBarController", sender: nil)
                
        },  failure: { (responseData) in
                self.HUD.hide(animated: true)
                showWarningAlert(viewController: self,
                                 Message: String(format: NSLocalizedString("ERROR_MESSAGE_REGISTER_FAIL", comment: ""), responseData),
                                 OkAction: nil)
        })
    }
    
    
    // MARK: - PatternLockDelegate
    func resultOfPatternLock(resultType: PatternLockResultType, patternString: String) {
        print("PatternLockResult:\(resultType)")
        
        //        self.myActivityIndicatorView.stopAnimating()
        //        self.setViewWait()
        
        switch displayMode {
        case .DISPLAY_MODE_REGISTERATION:
            
            switch resultType {
            case .RESULT_TYPE_OK:
                DataManager.currentUser.password = patternString
                break
            case .RESULT_TYPE_FAIL:
                showWarningAlert(viewController: self, Message: NSLocalizedString("SET_PASSCODE_FAILED", comment: ""), OkAction: nil)
                break
            case .RESULT_TYPE_CANCEL:
                
                break
            }
            
            break
        case .DISPLAY_MODE_EDIT_PROFILE:
            
            switch resultType {
            case .RESULT_TYPE_OK:
                let user:User = DataManager.currentUser
                user.password = patternString
                
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
        if (segue.identifier == "PatternLockViewController") {
            let lockVC = segue.destination as! PatternLockViewController
            if displayMode == .DISPLAY_MODE_REGISTERATION {
                lockVC.showLockStatus = ShowLockStatus.SHOW_LOCK_STATUS_SET_PATTERN
            } else {
                lockVC.showLockStatus = ShowLockStatus.SHOW_LOCK_STATUS_CHANGE_PATTERN
            }
            lockVC.patternLockDelegate = self
        }
    }
    
}
