//
//  PatternLockViewController.swift
//  AppTapia
//
//  Created by Andy 01/09/17.
//

import UIKit
import DDPatternLock
import MBProgressHUD
import CryptoSwift

enum ShowLockStatus: String {
    case SHOW_LOCK_STATUS_SET_PATTERN = "SHOW_LOCK_STATUS_SET_PATTERN"
    case SHOW_LOCK_STATUS_ENTER_PATTERN = "SHOW_LOCK_STATUS_ENTER_PATTERN"
    case SHOW_LOCK_STATUS_CHANGE_PATTERN = "SHOW_LOCK_STATUS_CHANGE_PATTERN"
}

enum InfoStatus: String {
    case INFO_STATUS_SET_PATTERN_SET = "INFO_STATUS_SET_PATTERN_SET"
    case INFO_STATUS_SET_PATTERN_CONFIRM = "INFO_STATUS_SET_PATTERN_CONFIRM"
    case INFO_STATUS_SET_PATTERN_SUCCESS = "INFO_STATUS_SET_PATTERN_SUCCESS"
    case INFO_STATUS_SET_PATTERN_FAIL = "INFO_STATUS_SET_PATTERN_FAIL"
    case INFO_STATUS_ENTER_PATTERN_ENTER = "INFO_STATUS_ENTER_PATTERN_ENTER"
    case INFO_STATUS_ENTER_PATTERN_SUCCESS = "INFO_STATUS_ENTER_PATTERN_SUCCESS"
    case INFO_STATUS_ENTER_PATTERN_FAIL = "INFO_STATUS_ENTER_PATTERN_FAIL"
    case INFO_STATUS_CHANGE_PATTERN_OLD = "INFO_STATUS_CHANGE_PATTERN_OLD"
    case INFO_STATUS_CHANGE_PATTERN_SET = "INFO_STATUS_CHANGE_PATTERN_SET"
    case INFO_STATUS_CHANGE_PATTERN_CONFIRM = "INFO_STATUS_CHANGE_PATTERN_CONFIRM"
    case INFO_STATUS_CHANGE_PATTERN_SUCCESS = "INFO_STATUS_CHANGE_PATTERN_SUCCESS"
    case INFO_STATUS_CHANGE_PATTERN_FAIL = "INFO_STATUS_CHANGE_PATTERN_FAIL"
}

enum PatternLockResultType: String {
    case RESULT_TYPE_OK = "RESULT_TYPE_OK"
    case RESULT_TYPE_FAIL = "RESULT_TYPE_FAIL"
    case RESULT_TYPE_CANCEL = "RESULT_TYPE_CANCEL"
}

protocol PatternLockDelegate {
    func resultOfPatternLock(resultType: PatternLockResultType, patternString: String)
}

class PatternLockViewController: UIViewController, LockScreenDelegate {

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var lockScreenView: SPLockScreen!
    @IBOutlet var infoLabel: UILabel!
    var patternLockDelegate:PatternLockDelegate?
    var HUD: MBProgressHUD!
    var settedPasscode = ""
    var showLockStatus = ShowLockStatus.SHOW_LOCK_STATUS_ENTER_PATTERN
    var infoLabelStatus = InfoStatus.INFO_STATUS_SET_PATTERN_SET
    
    
    // MARK: - Portrait only
//    override func shouldAutorotate() -> Bool {
//        return false
//    }
//    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.Portrait
//    }
    
    
    override func viewDidLoad() {

        lockScreenView = SPLockScreen.init(
            frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.width),
            andNodeRadius: 31,
            andOuterRadius: 33,
            andOutColor: COLOR_GREY_A50,
            andInnerColor: COLOR_BLACK,
            andHighlight: COLOR_GREY_A50,
            andLineColor: COLOR_GREY_A50,
            andLineGridColor: COLOR_GREY_A50)
        
        self.lockScreenView.center = self.view.center
        self.lockScreenView.delegate = self
        self.view.addSubview(self.lockScreenView)
        
        switch showLockStatus {
        case .SHOW_LOCK_STATUS_SET_PATTERN:
            infoLabelStatus = .INFO_STATUS_SET_PATTERN_SET
            
        case .SHOW_LOCK_STATUS_ENTER_PATTERN:
            infoLabelStatus = .INFO_STATUS_ENTER_PATTERN_ENTER
            
        case .SHOW_LOCK_STATUS_CHANGE_PATTERN:
            infoLabelStatus = .INFO_STATUS_CHANGE_PATTERN_SET
        }
        
        
        updateOutlook()

    }
    
    func updateOutlook() {

        switch (self.infoLabelStatus) {
        case .INFO_STATUS_SET_PATTERN_SET:
            self.infoLabel.text = "パターンを設定してください"
            break
        case .INFO_STATUS_SET_PATTERN_CONFIRM:
            self.infoLabel.text = "パターンを設定してください（確認）"
            break
        case .INFO_STATUS_SET_PATTERN_SUCCESS:
            self.infoLabel.text = "パターンを設定しました"
            break
        case .INFO_STATUS_SET_PATTERN_FAIL:
            self.infoLabel.text = "パターンが設定できませんでした"
            break
        case .INFO_STATUS_ENTER_PATTERN_ENTER:
            self.infoLabel.text = "設定したパターンを描いてください"
            break
        case .INFO_STATUS_ENTER_PATTERN_SUCCESS:
            self.infoLabel.text = "パターンが一致しました"
            break
        case .INFO_STATUS_ENTER_PATTERN_FAIL:
            self.infoLabel.text = "パターンが違います。"
            break
        case .INFO_STATUS_CHANGE_PATTERN_OLD:
            self.infoLabel.text = "設定したパターンを描いてください"
            break
        case .INFO_STATUS_CHANGE_PATTERN_SET:
            self.infoLabel.text = "新しいパターンを設定してください"
            break
        case .INFO_STATUS_CHANGE_PATTERN_CONFIRM:
            self.infoLabel.text = "もう一度設定してください（確認）"
            break
        case .INFO_STATUS_CHANGE_PATTERN_SUCCESS:
            self.infoLabel.text = "パターンが変更されました"
            break
        case .INFO_STATUS_CHANGE_PATTERN_FAIL:
            self.infoLabel.text = "パターンを変更できませんでした"
            break
        }
        
    }
    
    func lockScreen(_ lockScreen: SPLockScreen!, didEndWithPattern patternNumber: String!) {
        var finalCode = ""
        for code in patternNumber {
            finalCode = "\(finalCode)\(String(Int(String(code))!+1))"
        }
        print("FinalPatternNumber:\(finalCode)")
        
        if finalCode.count < 4 {
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_PATTERN_TOO_SHORT", comment: ""), OkAction: nil)
            return
        }
        
        finalCode = finalCode.sha1()
        
        switch (self.infoLabelStatus) {
        case .INFO_STATUS_SET_PATTERN_SET:
            settedPasscode = finalCode
            infoLabelStatus = .INFO_STATUS_SET_PATTERN_CONFIRM
            updateOutlook()
            break
        case .INFO_STATUS_SET_PATTERN_CONFIRM:
            if settedPasscode == finalCode {
                // Set Pattern success
                self.patternLockDelegate!.resultOfPatternLock(resultType: .RESULT_TYPE_OK, patternString: settedPasscode)
                self.dismiss(animated: true, completion: nil)
            } else {
                infoLabelStatus = .INFO_STATUS_SET_PATTERN_SET
                showWarningAlert(viewController: self, Message: "パターンが違います", OkAction: nil)
            }
            updateOutlook()
            break
        case .INFO_STATUS_SET_PATTERN_SUCCESS:
            break
        case .INFO_STATUS_SET_PATTERN_FAIL:
            break
        case .INFO_STATUS_ENTER_PATTERN_ENTER:
            // SocketIO appLogin
            settedPasscode = finalCode
            self.performSegue(withIdentifier: "MainTabBarController", sender: nil)
            //doAppLogin()
            break
        case .INFO_STATUS_ENTER_PATTERN_SUCCESS:
            break
        case .INFO_STATUS_ENTER_PATTERN_FAIL:
            break
        case .INFO_STATUS_CHANGE_PATTERN_OLD:
            break
        case .INFO_STATUS_CHANGE_PATTERN_SET:
            settedPasscode = finalCode
            infoLabelStatus = .INFO_STATUS_CHANGE_PATTERN_CONFIRM
            updateOutlook()
            break
        case .INFO_STATUS_CHANGE_PATTERN_CONFIRM:
            if settedPasscode == finalCode {
                //SocketIO changePattern
                doChangePattern()
            } else {
                infoLabelStatus = .INFO_STATUS_SET_PATTERN_SET
                updateOutlook()
                showWarningAlert(viewController: self, Message: "パターンが違います", OkAction: nil)
            }
            break
        case .INFO_STATUS_CHANGE_PATTERN_SUCCESS:
            break
        case .INFO_STATUS_CHANGE_PATTERN_FAIL:
            break
        }
    }
    
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.patternLockDelegate!.resultOfPatternLock(resultType: .RESULT_TYPE_CANCEL, patternString: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    /// doAppLogin
    func doAppLogin() {
        HUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("LOADING", comment: "")

        let token = LibraryAPI.shared.appData.sessionToken
        
        print("try login")
//        print(token)
        print(settedPasscode)
        
        LibraryAPI.shared.login(token: token, passcode: settedPasscode) {
            (responseString: String, responseData: [AnyObject]) in
            
            print("Register result: \(responseString)")
            self.HUD.hide(animated: true)

            // login success or fail
            if responseString == SOCKETIO_EVENT_PASSWORD_CONFIRM_SUCCESS_TAG {
                self.performSegue(withIdentifier: "MainTabBarController", sender: nil)
                //self.patternLockDelegate!.resultOfPatternLock(resultType: .RESULT_TYPE_OK, patternString: self.settedPasscode)
                //self.dismiss(animated: true, completion: nil)
            } else if responseString == SOCKETIO_EVENT_PASSWORD_CONFIRM_FAIL_TAG {
                self.infoLabelStatus = .INFO_STATUS_ENTER_PATTERN_ENTER
                self.updateOutlook()
                showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_LOGIN_INCORRECT_PATTERN", comment: ""), OkAction: nil)
            }
        }
    }
    
    /// doChangePattern
    func doChangePattern() {
        HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("LOADING", comment: "")
        
        print("doChangePattern")

        let currentData:User = DataManager.currentUser
        
        LibraryAPI.shared.changePassword(ID: currentData.id, password: settedPasscode, success: { _ in
            self.HUD.hide(animated: true)
            self.patternLockDelegate!.resultOfPatternLock(resultType: .RESULT_TYPE_OK, patternString: self.settedPasscode)
            self.dismiss(animated: true, completion: nil)
        }, failure: { _ in
            self.HUD.hide(animated: true)
            self.infoLabelStatus = .INFO_STATUS_ENTER_PATTERN_ENTER
            self.updateOutlook()
            showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_CHANGE_PATTERN_FAILED", comment: ""), OkAction: nil)
        })
        
    }
}
